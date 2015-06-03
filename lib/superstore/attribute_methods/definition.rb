module Superstore
  module AttributeMethods
    class Definition
      attr_reader :name, :type
      def initialize(model, name, type_class, options)
        @name = name.to_s
        @type = type_class.new(model, options)
      end

      def default
        type.default
      end

      def instantiate(value)
        value = value.nil? ? type.default : value
        return if value.nil?

        value.kind_of?(String) ? type.decode(value) : type.typecast(value)
      end
    end
  end
end
