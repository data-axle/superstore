module CassandraObject
  module Transactions
    class State
      attr_accessor :action, :record, :original_attributes
      def initialize(action, record)
        @action = action
        @record = record
        @original_attributes = record.changed_attributes.deep_dup
      end

      def rollback!
        case action
        when :create
          record.class.remove(record.id)
        when :update
          record.class.write(record.id, original_attributes)
        when :destroy
          record.class.write(record.id, original_attributes)
        end
      end
    end

    class Savepoint
      attr_accessor :states
      def initialize
        self.states = []
      end

      def add_state(action, record)
        states << State.new(action, record)
      end

      def rollback!
        states.reverse_each(&:rollback!)
      end
    end

    extend ActiveSupport::Concern

    included do
      class_attribute :savepoints
      self.savepoints = []
    end

    module ClassMethods
      def transaction
        self.savepoints.push Savepoint.new
        yield
        savepoints.pop
      rescue => e
        savepoints.pop.rollback!
      end

      def add_savepoint_state(action, record)
        unless savepoints.empty?
          savepoints.last.add_state(action, record)
        end
      end
    end

    def destroy
      self.class.add_savepoint_state(:destroy, self)
      super
    end

    private
      def create
        self.class.add_savepoint_state(:create, self)
        super
      end

      def update
        self.class.add_savepoint_state(:update, self)
        super        
      end
  end
end
