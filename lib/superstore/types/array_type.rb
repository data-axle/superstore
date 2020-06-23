module Superstore
  module Types
    class ArrayType < Base
      def cast_value(value)
        Array(value)
      end
    end
  end
end
