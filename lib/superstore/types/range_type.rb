module Superstore
  module Types
    class RangeType < BaseType
      class_attribute :subtype

      def encode(range)
        [
          convert_begin(:encode, range.begin),
          convert_begin(:encode, range.end)
        ]
      end

      def decode(range_tuple)
        convert_begin(:decode, range_tuple[0]) .. convert_end(:decode, range_tuple[1])
      end


      def typecast(value)
        if value.is_a?(Range)
          value
        elsif value.is_a?(Array) && value.size == 2
          begin
            convert_begin(:typecast, value[0])..convert_end(:typecast, value[1])
          rescue ArgumentError
          end
        end
      end

      private

      def convert_begin(method, value)
        subtype.send(method, value)
      end

      def convert_end(method, value)
        subtype.send(method, value)
      end
    end
  end
end
