module Superstore
  module Types
    class ArrayType < BaseType
      def decode(val)
        val unless val.blank?
      end

      def typecast(value)
        value.to_a
      end
    end
  end
end
