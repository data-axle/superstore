class Time
  def self.rfc3339(str)
    parts = Date._rfc3339(str)

    raise ArgumentError, "invalid date" if parts.empty?

    Time.new(
      parts.fetch(:year),
      parts.fetch(:mon),
      parts.fetch(:mday),
      parts.fetch(:hour),
      parts.fetch(:min),
      parts.fetch(:sec) + parts.fetch(:sec_fraction, 0),
      parts.fetch(:offset)
    )
  end
end

module Superstore
  module Types
    class TimeType < BaseType
      def encode(time)
        raise ArgumentError.new("#{time.inspect} does not respond to #to_time") unless time.is_a?(Time) || time.respond_to?(:to_time)
        time = time.to_time unless time.is_a?(Time)
        time.utc.xmlschema(6)
      end

      def decode(str)
        Time.rfc3339(str).in_time_zone if str
      rescue ArgumentError
        Time.parse(str).in_time_zone rescue nil
      end

      def typecast(value)
        value.to_time.in_time_zone rescue nil
      end
    end
  end
end
