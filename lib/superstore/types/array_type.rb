module Superstore
  module Types
    class ArrayType < Base
      def cast_value(value)
        value.present? ? Array(value) : nil
      end
    end
  end
end
