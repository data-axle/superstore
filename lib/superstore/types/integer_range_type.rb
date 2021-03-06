module Superstore
  module Types
    class IntegerRangeType < RangeType
      self.subtype = IntegerType.new

      def serialize_for_open_ended(value)
        value&.abs == Float::INFINITY ? nil : super
      end

      def convert_min(method, value)
        value.nil? ? -Float::INFINITY : super
      end
    end
  end
end
