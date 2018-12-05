module Superstore
  module AttributeMethods
    class Definition
      attr_reader :name, :type
      def initialize(model, name, type_class, options)
        @name = name.to_s
        @type = type_class.new(model, options)
      end

      def encode(value)
        type.encode(value.value) unless value&.value&.nil?
      end

      def decode(value)
        type.decode(value.value) unless value&.value&.nil?
      end

      def typecast(name, value)
        type.typecast(name, value) unless value.nil?
      end
    end
  end
end
