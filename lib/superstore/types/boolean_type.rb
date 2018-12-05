module Superstore
  module Types
    class BooleanType < BaseType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0']

      def typecast(name, value)
        if TRUE_VALS.include?(value)
          ActiveModel::Attribute.from_user(name, true, ActiveModel::Type::Boolean.new)
        elsif FALSE_VALS.include?(value)
          ActiveModel::Attribute.from_user(name, false, ActiveModel::Type::Boolean.new)
        end
      end
    end
  end
end
