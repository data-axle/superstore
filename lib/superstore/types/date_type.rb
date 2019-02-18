module Superstore
  module Types
    class DateType < ActiveModel::Type::Value
      FORMAT = '%Y-%m-%d'

      def serialize(value)
        value.strftime(FORMAT) if value
      end

      def deserialize(str)
        Date.strptime(str, FORMAT) if str
      end

      def cast_value(value)
        value.to_date rescue nil
      end
    end
  end
end
