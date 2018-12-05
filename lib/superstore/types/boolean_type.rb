module Superstore
  module Types
    class BooleanType < BaseType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0']

      def typecast(name, value, current_value = nil)
        current_value ||= ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::Boolean.new)

        if TRUE_VALS.include?(value)
          ActiveModel::Attribute.from_user(name, true, ActiveModel::Type::Boolean.new, current_value)
        elsif FALSE_VALS.include?(value)
          ActiveModel::Attribute.from_user(name, false, ActiveModel::Type::Boolean.new, current_value)
        end
      end
    end
  end
end
