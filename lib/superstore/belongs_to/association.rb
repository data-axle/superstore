module Superstore
  module BelongsTo
    class Association
      attr_reader :owner, :reflection
      attr_accessor :record_variable
      delegate :options, to: :reflection

      def initialize(owner, reflection)
        @owner = owner
        @reflection = reflection
      end

      def reader
        unless loaded?
          if record_id = owner.send(reflection.foreign_key).presence
            self.record_variable = association_class.find_by_id(record_id)
          else
            self.record_variable = nil
          end
          @loaded = true
        end

        record_variable
      end

      def writer(record)
        self.record_variable = record
        @loaded = true
        owner.send("#{reflection.foreign_key}=", record.try(:id))
        if reflection.polymorphic?
          owner.send("#{reflection.polymorphic_column}=", record.class.name)
        end
      end

      def association_class
        association_class_name.constantize
      end

      def association_class_name
        reflection.polymorphic? ? owner.send(reflection.polymorphic_column) : reflection.class_name
      end

      def loaded?
        @loaded
      end
    end
  end
end
