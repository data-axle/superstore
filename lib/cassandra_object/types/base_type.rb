module CassandraObject
  module Types
    class BaseType
      attr_accessor :options
      def initialize(options = {})
        @options = options
      end

      def default
        options[:default].dup if options[:default]
      end

      def encode(value)
        value.to_s
      end

      def decode(str)
        str
      end

      def wrap(record, name, value)
        value
      end
    end
  end
end