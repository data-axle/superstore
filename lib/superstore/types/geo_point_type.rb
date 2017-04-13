module Superstore
  module Types
    class GeoPointType < BaseType
      def typecast(value)
        case value
        when Array
          {lat: value[0]&.to_f, lon: value[1]&.to_f }
        when Hash
          if value.keys.sort == %i(lat lon)
            {lat: value[:lat].to_f, lon: value[:lon].to_f}
          elsif value.keys.sort == %w(lat lon)
            {lat: value['lat'].to_f, lon: value['lon'].to_f}
          end
        when String
          intermediate = value.split(/[,\s]+/)
          standardize(intermediate)
        end
      end
    end
  end
end
