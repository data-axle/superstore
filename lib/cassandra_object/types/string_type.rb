module CassandraObject
  module Types
    class StringType < BaseType
      def encode(str)
        raise ArgumentError.new("#{str.inspect} is not a String") unless str.kind_of?(String)
        (str.frozen? ? str.dup : str).force_encoding('UTF-8')
      end
    end
  end
end
