module CassandraObject
  module Types
    class TimeType < BaseType
      REGEX = /\A\s*
                (-?\d+)-(\d\d)-(\d\d)
                T
                (\d\d):(\d\d):(\d\d)
                (\.\d*)?
                (Z|[+-]\d\d:\d\d)?
                \s*\z/ix

      def encode(time)
        raise ArgumentError.new("#{time.inspect} is not a Time") unless time.kind_of?(Time)
        time.utc.xmlschema(6)
      end

      def decode(str)
        return nil unless str && str.match(TimeType::REGEX)
        Time.xmlschema(str).in_time_zone
      end
    end
  end
end
