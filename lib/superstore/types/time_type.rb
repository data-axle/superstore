module Superstore
  module Types
    class TimeType < BaseType
      def encode(time)
        raise ArgumentError.new("#{time.inspect} does not respond to #to_time") unless time.is_a?(Time) || time.respond_to?(:to_time)
        time = time.to_time unless time.is_a?(Time)
        time.utc.xmlschema(6)
      end

      def decode(str)
        Time.iso8601(str).in_time_zone if str
      rescue

      end
    end
  end
end
