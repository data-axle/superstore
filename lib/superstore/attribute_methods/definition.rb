module Superstore
  module AttributeMethods
    class Definition
      attr_reader :name, :type
      def initialize(model, name, type_class, options)
        @name = name.to_s
        @type = type_class.new(model, options)
      end

      def encode(value)
        type.encode(value) unless value.nil?
      end

      def decode(value)
        type.decode(value) unless value.nil?
      end

      def typecast(value)
        type.typecast(value) unless value.nil?
      end
    end
  end
end
