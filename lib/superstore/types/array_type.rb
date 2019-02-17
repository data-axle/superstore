module Superstore
  module Types
    class ArrayType < ActiveModel::Type::Value
      def cast_value(value)
        Array(value)
      end
    end
  end
end
