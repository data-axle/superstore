module Superstore
  module Types
    class ArrayType < BaseType
      def typecast(value)
        Array(value)
      end
    end
  end
end
