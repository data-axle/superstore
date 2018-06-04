module Superstore
  module Types
    class IntegerRangeType < RangeType
      self.subtype = IntegerType.new(nil)

      def encode_for_open_ended(value)
        value.abs == Float::INFINITY ? nil : super
      end

      def convert_begin(method, value)
        value.nil? ? -Float::INFINITY : super
      end

      def convert_end(method, value)
        value.nil? ? Float::INFINITY : super
      end
    end
  end
end
