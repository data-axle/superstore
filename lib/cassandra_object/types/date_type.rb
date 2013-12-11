module CassandraObject
  module Types
    class DateType < BaseType
      FORMAT = '%Y-%m-%d'
      REGEX = /\A\d{4}-\d{2}-\d{2}\Z/

      def encode(value)
        raise ArgumentError.new("#{value.inspect} is not a Date") unless value.kind_of?(Date)
        value.strftime(FORMAT)
      end

      def decode(str)
        return nil if str.empty?
        Date.parse(str)
      end

      def wrap(record, name, value)
        value.to_date
      end
    end
  end
end
