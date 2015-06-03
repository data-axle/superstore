module Superstore
  module AttributeMethods
    module Typecasting
      extend ActiveSupport::Concern

      included do
        class_attribute :attribute_definitions
        self.attribute_definitions = {}

        %w(array boolean date float integer json string time).each do |type|
          instance_eval <<-EOV, __FILE__, __LINE__ + 1
            def #{type}(*args)
              options = args.extract_options!
              args.each do |name|
                attribute(name, options.merge(:type => :#{type}))
              end
            end
          EOV
        end
      end

      module ClassMethods
        def inherited(child)
          super
          child.attribute_definitions = attribute_definitions.dup
        end

        #
        # attribute :name, type: :string
        # attribute :ammo, type: :integer
        #
        def attribute(name, options)
          type_name  = options[:type]
          type_class = Superstore::Type.get_type_class(type_name) || (raise "Unknown type #{type_name}")

          attribute_definitions[name.to_s] = AttributeMethods::Definition.new(self, name, type_class, options)
        end

        def typecast_attribute(name, value)
          if attribute_definition = attribute_definitions[name.to_s]
            attribute_definition.instantiate(value)
          else
            raise NoMethodError, "Unknown attribute #{name.inspect}"
          end
        end

        def type_for(attribute)
          attribute_definitions[attribute.to_s].type
        end
      end
    end
  end
end
