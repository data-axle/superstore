module Superstore
  module Types
    class FloatType < BaseType
      def typecast(name, value)
        float = Float(value) rescue nil
        ActiveModel::Attribute.from_user(name, float, ActiveModel::Type::Float.new)
      end
    end
  end
end
