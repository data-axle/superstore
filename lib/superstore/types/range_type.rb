module Superstore
  module Types
    class RangeType < BaseType
      class_attribute :subtype

      def encode(range_hash)
        [
          convert(:encode, range_hash[:lower]),
          convert(:encode, range_hash[:upper])
        ]
      end

      def decode(range_tuple)
        {
          lower: convert(:decode, range_tuple[0]),
          upper: convert(:decode, range_tuple[1])
        }
      end


      def typecast(value)
        {
          lower: convert(:typecast, value[:lower] || value['lower']),
          upper: convert(:typecast, value[:upper] || value['upper'])
        }
      end

      private

      def convert(method, value)
        subtype.send(method, value) unless value.nil?
      end
      #
      def to_range_hash(value)
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
