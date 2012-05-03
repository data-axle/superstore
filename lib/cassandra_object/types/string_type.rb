module CassandraObject
  module Types
    class StringType < BaseType
      def encode(str)
        raise ArgumentError.new("#{str.inspect} is not a String") unless str.kind_of?(String)
        str.dup
      end

      def wrap(record, name, value)
        value = value.to_s
        (value.frozen? ? value.dup : value).force_encoding('UTF-8')
      end
    end
  end
end