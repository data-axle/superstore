module Superstore
  module Types
    class RangeType < BaseType
      class_attribute :subtype

      def encode(range)
        [
          encode_for_open_ended(range.begin),
          encode_for_open_ended(range.end)
        ]
      end

      def decode(range_tuple)
        if range_tuple.is_a? Range
          range_tuple
        else
          range = convert_min(:decode, range_tuple[0]) .. convert_max(:decode, range_tuple[1])
          typecast(range)
        end
      end


      def typecast(value)
        if value.is_a?(Range) && value.begin < value.end
          value
        elsif value.is_a?(Array) && value.size == 2
          begin
            array = convert_min(:typecast, value[0])..convert_max(:typecast, value[1])
            typecast(array)
          rescue ArgumentError
          end
        end
      end

      private

      def encode_for_open_ended(value)
        subtype.encode(value)
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
