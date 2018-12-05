module Superstore
  module Types
    class IntegerType < BaseType
      def typecast(name, value, current_value = nil)
        current_value ||= ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::Integer.new)

        if value.is_a?(String)
          ActiveModel::Attribute.from_user(name, Integer(value, 10), ActiveModel::Type::Integer.new, current_value)
        else
          ActiveModel::Attribute.from_user(name, Integer(value), ActiveModel::Type::Integer.new, current_value)
        end
      rescue
        ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::Integer.new, current_value)
      end
    end
  end
end
