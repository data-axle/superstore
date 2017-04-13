module Superstore
  module Types
    class GeoPointType < BaseType
      def typecast(value)
        case value
        when Array
          to_float_or_nil(lat: value[0], lon: value[1])
        when Hash
          value = value.symbolize_keys!
          to_float_or_nil(lat: value[:lat], lon: value[:lon])
        when String
          typecast value.split(/[,\s]+/)
        end
      end

      private

      def to_float_or_nil(coords)
        if coords[:lat] && coords[:lon]
          coords.transform_values!(&:to_f)
        end
      end
    end
  end
end
