module Superstore
  module Types
    class DateType < ActiveModel::Type::Value
      FORMAT = '%Y-%m-%d'

      def serialize(value)
        value.strftime(FORMAT)
      end

      def deserialize(str)
        Date.strptime(str, FORMAT)
      end

      def cast_value(value)
        value.to_date rescue nil
      end
    end
  end
end
