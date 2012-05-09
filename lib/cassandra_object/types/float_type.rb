module CassandraObject
  module Types
    class FloatType < BaseType
      REGEX = /\A[-+]?\d+(\.\d+)?\Z/
      def encode(float)
        raise ArgumentError.new("#{float.inspect} is not a Float") unless float.kind_of?(Float)
        float.to_s
      end

      def decode(str)
        return nil if str.empty?
        raise ArgumentError.new("Cannot convert #{str} into a Float") unless str.kind_of?(String) && str.match(REGEX)
        str.to_f
      end
    end
  end
end