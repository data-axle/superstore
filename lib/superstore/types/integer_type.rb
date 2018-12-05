module Superstore
  module Types
    class IntegerType < BaseType
      def typecast(name, value)
        if value.is_a?(String)
          ActiveModel::Attribute.from_user(name, Integer(value, 10), ActiveModel::Type::Integer.new)
        else
          ActiveModel::Attribute.from_user(name, Integer(value), ActiveModel::Type::Integer.new)
        end
      rescue
        ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::Integer.new)
      end
    end
  end
end
