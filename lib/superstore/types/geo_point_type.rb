module Superstore
  module Types
    class GeoPointType < BaseType
      # def encode(int)
      #   raise ArgumentError.new("#{int.inspect} is not an Integer.") unless int.kind_of?(Integer)
      #
      #   int
      # end

      # def decode(str)
      #   str.to_i unless str.empty?
      # end

      def typecast(value)
        case value
        when Array
          {lat: value[0]&.to_f, lon: value[1]&.to_f }
        when Hash
          value.transform_values(&:to_f).symbolize_keys
          #  {lat: value['lat'], lon: value['lon']}
        when String
          intermediate = value.split(/[,\s]+/)
          standardize(definition, intermediate)
        else
          value
        end
      end
    end
  end
end
