module CassandraObject
  module Types
    class DateType
      FORMAT = '%Y-%m-%d'
      REGEX = /\A\d{4}-\d{2}-\d{2}\Z/
      def encode(date)
        raise ArgumentError.new("#{self} requires a Date") unless date.kind_of?(Date)
        date.strftime(FORMAT)
      end

      def decode(str)
        return nil if str.empty?
        raise ArgumentError.new("Cannot convert #{str} into a Date") unless str.kind_of?(String) && str.match(REGEX)
        Date.strptime(str, FORMAT)
      end
    end
  end
end