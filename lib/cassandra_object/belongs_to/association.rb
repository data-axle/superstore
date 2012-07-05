module CassandraObject
  module BelongsTo
    class Association
      attr_reader :owner, :reflection
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
        end

        record_variable
      end

      def writer(record)
        self.record_variable = record
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

      def record_variable
        owner.instance_variable_get(reflection.instance_variable_name)
      end

      def record_variable=(record)
        owner.instance_variable_set(reflection.instance_variable_name, record)
      end

      def loaded?
        owner.instance_variable_defined?(reflection.instance_variable_name)
      end
    end
  end
end