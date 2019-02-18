module Superstore
  module Types
    class RangeType < ActiveModel::Type::Value
      class_attribute :subtype

      def serialize(range)
        if range
          [
            serialize_for_open_ended(range.begin),
            serialize_for_open_ended(range.end)
          ]
        end
      end

      def deserialize(range_tuple)
        if range_tuple.is_a? Range
          range_tuple
        elsif range_tuple.is_a?(Array)
          range = convert_min(:deserialize, range_tuple[0]) .. convert_max(:deserialize, range_tuple[1])
          cast_value(range)
        end
      end

      def cast_value(value)
        if value.is_a?(Range) && value.begin < value.end
          value
        elsif value.is_a?(Array) && value.size == 2
          begin
            array = convert_min(:cast_value, value[0])..convert_max(:cast_value, value[1])
            cast_value(array)
          rescue ArgumentError
          end
        end
      end

      private

      def serialize_for_open_ended(value)
        subtype.serialize(value)
      end

      def convert_min(method, value)
        subtype.send(method, value)
      end

      def convert_max(method, value)
        subtype.send(method, value)
      end
    end
  end
end
