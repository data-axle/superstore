module CassandraObject
  module Savepoints
    class Rollback
      attr_accessor :action, :record, :rollback_attributes
      def initialize(action, record)
        @action = action
        @record = record
        if action == :update
          @rollback_attributes = record.changed_attributes.deep_dup
        elsif action == :create
          @rollback_attributes = record.attributes.deep_dup
        end
      end

      def run!
        case action
        when :destroy
          record.class.remove(record.id)
        when :create, :update
          record.class.write(record.id, rollback_attributes)
        end
      end
    end

    class Savepoint
      attr_accessor :rollbacks
      def initialize
        self.rollbacks = []
      end

      def add_rollback(action, record)
        states << Rollback.new(action, record)
      end

      def rollback!
        rollbacks.reverse_each(&:run!)
      end
    end

    extend ActiveSupport::Concern

    included do
      class_attribute :savepoints
      self.savepoints = []
    end

    module ClassMethods
      def savepoint
        self.savepoints.push Savepoint.new
        yield
        savepoints.pop
      rescue => e
        savepoints.pop.rollback!
      end

      def add_savepoint_rollback(action, record)
        unless savepoints.empty?
          savepoints.last.add_rollback(action, record)
        end
      end
    end

    def destroy
      self.class.add_savepoint_rollback(:create, self)
      super
    end

    private
      def create
        self.class.add_savepoint_rollback(:destroy, self)
        super
      end

      def update
        self.class.add_savepoint_rollback(:update, self)
        super        
      end
  end
end
