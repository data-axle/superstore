module Superstore
  module Types
    class RangeType < BaseType
      class_attribute :subtype

      def encode(range)
        range.map { |v| subtype.encode(v) }
      end

      def decode(range)
        range.map { |v| subtype.decode(v) }
      end

      def typecast(value)
        to_range_tuple(value).map! { |v| subtype.typecast(v) }
      end

      private

      def to_range_tuple(value)
        if value.is_a?(Range)
          [value.begin, value.end]
        elsif value.is_a?(Hash)
          [value[:lower], value[:upper]]
        elsif value.is_a?(Array)
          [value[0], value[1]]
        end
      end
    end
  end
end
