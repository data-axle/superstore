module Superstore
  module Types
    class DateType < BaseType
      FORMAT = '%Y-%m-%d'

      def encode(value)
        value.strftime(FORMAT)
      end

      def decode(str)
        Date.strptime(str, FORMAT)
      end

      def typecast(name, value, current_value = nil)
        current_value ||= ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::Date.new)

        date = value.to_date rescue nil
        ActiveModel::Attribute.from_user(name, date, ActiveModel::Type::Date.new, current_value)
      end
    end
  end
end
