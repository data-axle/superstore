module Superstore
  module Types
    class IntegerRangeType < RangeType
      self.subtype = IntegerType.new(nil)

      def convert_begin(method, value)
        value.nil? ? -Float::INFINITY : super
      end

      def convert_end(method, value)
        value.nil? ? Float::INFINITY : super
      end
    end
  end
end
