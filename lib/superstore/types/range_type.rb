module Superstore
  module Types
    class RangeType < BaseType
      class_attribute :subtype

      def encode(range)
        [
          convert(:encode, range.begin),
          convert(:encode, range.end)
        ]
      end

      def decode(range_tuple)
        convert(:decode, range_tuple[0]) .. convert(:decode, range_tuple[1])
      end


      def typecast(value)
        if value.is_a?(Range)
          value
        elsif value.is_a?(Array) && value.size == 2
          convert(:typecast, value[0]) .. convert(:typecast, value[1])
        end
      end

      private

      def convert(method, value)
        subtype.send(method, value) unless value.nil?
      end
    end
  end
end
