module CassandraObject
  module AttributeMethods
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      class_attribute :attribute_definitions
      self.attribute_definitions = {}

      attribute_method_suffix("", "=")

      %w(array boolean date float integer time time_with_zone string).each do |type|
        instance_eval <<-EOV, __FILE__, __LINE__ + 1
          def #{type}(name, options = {})                                   # def string(name, options = {})
            attribute(name, options.update(type: :#{type}))                 #   attribute(name, options.update(type: :string))
          end                                                               # end
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
        type  = options.delete :type
        coder = options.delete :coder

        if type.is_a?(Symbol)
          coder = CassandraObject::Type.get_coder(type) || (raise "Unknown type #{type}")
        elsif coder.nil?
          raise "Must supply a :coder for #{name}"
        end

        attribute_definitions[name.to_sym] = AttributeMethods::Definition.new(name, coder, options)
      end

      def json(name, options = {})
        attribute(name, options.update(type: :hash))
      end

      def instantiate_attribute(record, name, value)
        if attribute_definition = attribute_definitions[name.to_sym]
          attribute_definition.instantiate(record, value)
        else
          raise NoMethodError, "Unknown attribute #{name.inspect}"
        end
      end

      def define_attribute_methods
        return if attribute_methods_generated?
        super(attribute_definitions.keys)
        @attribute_methods_generated = true
      end

      def attribute_methods_generated?
        @attribute_methods_generated ||= false
      end
    end

    def write_attribute(name, value)
      @attributes[name.to_s] = self.class.instantiate_attribute(self, name, value)
    end

    def read_attribute(name)
      @attributes[name.to_s]
    end

    def attributes=(attributes)
      attributes.each do |(name, value)|
        send("#{name}=", value)
      end
    end

    def method_missing(method_id, *args, &block)
      if !self.class.attribute_methods_generated?
        self.class.define_attribute_methods
        send(method_id, *args, &block)
      else
        super
      end
    end

    def respond_to?(*args)
      self.class.define_attribute_methods unless self.class.attribute_methods_generated?
      super
    end

    protected
      def attribute_method?(name)
        !!attribute_definitions[name.to_sym]
      end

    private
      def attribute(name)
        read_attribute(name)
      end
    
      def attribute=(name, value)
        write_attribute(name, value)
      end
  end
end
