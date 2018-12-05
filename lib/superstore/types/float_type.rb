module Superstore
  module Types
    class FloatType < BaseType
      def typecast(name, value, current_value = nil)
        current_value ||= ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::Float.new)

        float = Float(value) rescue nil
        ActiveModel::Attribute.from_user(name, float, ActiveModel::Type::Float.new, current_value)
      end
    end
  end
end
