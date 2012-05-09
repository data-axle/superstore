module CassandraObject
  module AttributeMethods
    module Typecasting
      extend ActiveSupport::Concern

      included do
        class_attribute :attribute_definitions
        self.attribute_definitions = {}

        %w(array boolean date float integer json string time).each do |type|
          instance_eval <<-EOV, __FILE__, __LINE__ + 1
            def #{type}(name, options = {})                             # def string(name, options = {})
              attribute(name, options.update(type: :#{type}))           #   attribute(name, options.update(type: :string))
            end                                                         # end
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
        # attribute :ammo, type: Ammo, coder: AmmoCodec
        # 
        def attribute(name, options)
          type  = options[:type]
          coder = options[:coder]

          if type.is_a?(Symbol)
            coder = CassandraObject::Type.get_coder(type) || (raise "Unknown type #{type}")
          elsif coder.nil?
            raise "Must supply a :coder for #{name}"
          end

          attribute_definitions[name.to_sym] = AttributeMethods::Definition.new(name, coder, options)
        end

        def typecast_attribute(record, name, value)
          if attribute_definition = attribute_definitions[name.to_sym]
            attribute_definition.instantiate(record, value)
          else
            raise NoMethodError, "Unknown attribute #{name.inspect}"
          end
        end

        def coder_for(attribute)
          attribute_definitions[attribute.to_sym].coder
        end
      end
    end
  end
end