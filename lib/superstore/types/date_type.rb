module Superstore
  module Types
    class DateType < BaseType
      FORMAT = '%Y-%m-%d'

      def encode(value)
        raise ArgumentError.new("#{value.inspect} is not a Date") unless value.kind_of?(Date)
        value.strftime(FORMAT)
      end

      def decode(str)
        Date.strptime(str, FORMAT) unless str.empty?
      rescue
        Date.parse(str)
      end

      def typecast(value)
        value.to_date
      end
    end
  end
end
