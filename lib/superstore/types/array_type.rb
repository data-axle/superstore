module Superstore
  module Types
    class ArrayType < Base
      def serialize(value)
        value if value.present?
      end

      def cast_value(value)
        Array(value)
      end
    end
  end
end
