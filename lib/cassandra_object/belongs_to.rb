module CassandraObject
  module BelongsTo
    extend ActiveSupport::Concern

    module ClassMethods
      # === Options
      # [:class_name]
      #   Use if the class cannot be inferred from the association
      # [:polymorphic]
      #   Specify if the association is polymorphic
      # Example:
      #   class Driver < CassandraObject::Base
      #   end
      #   class Truck < CassandraObject::Base
      #   end
      def belongs_to(name, options = {})
        instance_variable_name = "@#{name}"

        define_method("#{name}=") do |record|
          instance_variable_set(instance_variable_name, record)
          send("#{name}_id=", record.try(:id))
          if options[:polymorphic]
            send("#{name}_type=", record.class.name)
          end
        end

        define_method(name) do
          unless instance_variable_defined?(instance_variable_name)
            if record_id = send("#{name}_id").presence
              model_name = options[:polymorphic] ? send("#{name}_type") : (options[:class_name] || name.to_s.classify)
              instance_variable_set(instance_variable_name, model_name.constantize.find_by_id(record_id))
            else
              instance_variable_set(instance_variable_name, nil)
            end
          end

          instance_variable_get(instance_variable_name)
        end
      end
    end
  end
end