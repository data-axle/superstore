module Superstore
  module Types
    class ArrayType < BaseType
      def typecast(value)
        value.to_a
      end
    end
  end
end
