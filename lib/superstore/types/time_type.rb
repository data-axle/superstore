module Superstore
  module Types
    class TimeType < ActiveModel::Type::Value
      def serialize(time)
        raise ArgumentError.new("#{time.inspect} does not respond to #to_time") unless time.is_a?(Time) || time.respond_to?(:to_time)
        time = time.to_time unless time.is_a?(Time)
        time.utc.xmlschema(6)
      end

      def deserialize(str)
        Time.rfc3339(str).in_time_zone if str
      rescue ArgumentError
        Time.parse(str).in_time_zone rescue nil
      end

      def cast_value(value)
        value.to_time.in_time_zone rescue nil
      end
    end
  end
end
