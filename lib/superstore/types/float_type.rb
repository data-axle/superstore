module Superstore
  module Types
    class FloatType < BaseType
      REGEX = /\A[-+]?\d+(\.\d+)?\Z/
      def encode(float)
        raise ArgumentError.new("#{float.inspect} is not a Float") unless float.kind_of?(Float)
        float.to_s
      end

      def decode(str)
        return nil if str.empty?
        str.to_f
      end
    end
  end
end
