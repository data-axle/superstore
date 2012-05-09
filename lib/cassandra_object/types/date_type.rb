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
        Date.parse(str)
      end
    end
  end
end
