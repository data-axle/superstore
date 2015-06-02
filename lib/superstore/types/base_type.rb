module Superstore
  module Types
    class BaseType
      attr_accessor :options
      def initialize(options = {})
        @options = options
      end

      def default
        options[:default].duplicable? ? options[:default].dup : options[:default]
      end

      def encode(value)
        value
      end

      def decode(str)
        str
      end

      def typecast(value)
        value
      end
    end
  end
end
