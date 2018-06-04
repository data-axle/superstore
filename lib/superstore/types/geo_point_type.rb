module Superstore
  module Types
    class GeoPointType < BaseType
      def decode(value)
        {lat: value['lat'], lon: value['lon']}
      end

      def typecast(value)
        case value
        when String
          typecast value.split(/[,\s]+/)
        when Array
          to_float_or_nil(lat: value[0], lon: value[1])
        when Hash
          to_float_or_nil(lat: value[:lat] || value['lat'], lon: value[:lon] || value['lon'])
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
