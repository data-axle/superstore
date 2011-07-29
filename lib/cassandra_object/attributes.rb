module CassandraObject
  class Attribute
    attr_reader :name, :converter, :expected_type
    def initialize(name, converter, expected_type)
      @name          = name.to_s
      @converter     = converter
      @expected_type = expected_type
    end

    def check_value!(value)
      return value if value.nil?
      value.kind_of?(expected_type) ? value : converter.decode(value)
    end
  end

  module Attributes
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    module ClassMethods
      def attribute(name, options)
        if model_attributes.empty?
          self.model_attributes = {}.with_indifferent_access
        end

        if type_mapping = CassandraObject::Type.get_mapping(options[:type])
          converter = type_mapping.converter
          expected_type = type_mapping.expected_type
        elsif options[:converter]
          converter = options[:converter]
          expected_type = options[:type]
        else
          raise "Unknown type #{options[:type]}"
        end

        model_attributes[name] = Attribute.new(name, converter, expected_type)
      end

      def define_attribute_methods
        super(model_attributes.keys)
      end
    end

    included do
      class_attribute :model_attributes
      self.model_attributes = {}.with_indifferent_access

      attribute_method_suffix("", "=")      
    end

    def write_attribute(name, value)
      if ma = self.class.model_attributes[name]
        @attributes[name.to_s] = ma.check_value!(value)
      else
        raise NoMethodError, "Unknown attribute #{name.inspect}"
      end
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
        !!model_attributes[name.to_sym]
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
