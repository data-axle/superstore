module Superstore
  module Types
    class FloatType < BaseType
      def encode(float)
        float
      end

      def decode(str)
        str.to_f unless str.empty?
      end

      def typecast(value)
        value.to_f
      end
    end
  end
end
