module Superstore
  module Types
    class RangeType < BaseType
      class_attribute :subtype

      def encode(range)
        ordered = ordered_range(range)

        [
          encode_for_open_ended(ordered.min),
          encode_for_open_ended(ordered.max)
        ]
      end

      def decode(range_tuple)
        convert_min(:decode, range_tuple[0]) .. convert_max(:decode, range_tuple[1])
      end


      def typecast(value)
        if value.is_a?(Range)
          ordered_range(value)
        elsif value.is_a?(Array) && value.size == 2
          begin
            convert_min(:typecast, value[0])..convert_max(:typecast, value[1])
          rescue ArgumentError
          end
        end
      end

      private

      def ordered_range(range)
        Range.new(*[range.begin, range.end].sort)
      end

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
