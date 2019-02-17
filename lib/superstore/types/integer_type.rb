module Superstore
  module Types
    class IntegerType < ActiveModel::Type::Value
      def cast_value(value)
        if value.is_a?(String)
          Integer(value, 10)
        else
          Integer(value)
        end
      rescue
      end
    end
  end
end
