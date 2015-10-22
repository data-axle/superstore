module Superstore
  module Types
    class FloatType < BaseType
      def encode(float)
        float
      end

      def decode(str)
        return nil if str.empty?
        str.to_f
      end

      def typecast(value)
        value.to_f
      end
    end
  end
end
