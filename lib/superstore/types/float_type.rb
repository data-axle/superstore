module Superstore
  module Types
    class FloatType < ActiveModel::Type::Value
      def cast_value(value)
        Float(value) rescue nil
      end
    end
  end
end
