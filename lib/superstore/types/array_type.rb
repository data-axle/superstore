module Superstore
  module Types
    class ArrayType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def encode(array)
        array
      end

      def decode(val)
        return nil if val.blank?

        val
      end

      def typecast(value)
        value.to_a
      end
    end
  end
end
