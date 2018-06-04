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

      def typecast(value)
        value.to_date rescue nil
      end
    end
  end
end
