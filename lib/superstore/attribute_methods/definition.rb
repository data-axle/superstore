module Superstore
  module AttributeMethods
    class Definition
      attr_reader :name, :coder
      def initialize(name, coder, options)
        @name   = name.to_s
        @coder  = coder.new(options)
      end

      def default
        coder.default
      end

      def instantiate(record, value)
        value = value.nil? ? coder.default : value
        return if value.nil?

        value.kind_of?(String) ? coder.decode(value) : coder.typecast(value)
      end
    end
  end
end
