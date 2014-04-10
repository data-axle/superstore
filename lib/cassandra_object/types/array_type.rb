module CassandraObject
  module Types
    class ArrayType < BaseType
      def encode(array)
        raise ArgumentError.new("#{array.inspect} is not an Array") unless array.kind_of?(Array)
        array.to_a.to_json
      end

      def decode(str)
        return nil if str.blank?

        ActiveSupport::JSON.decode(str)
      end
    end
  end
end
