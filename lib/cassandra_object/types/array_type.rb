module CassandraObject
  module Types
    class ArrayType
      def encode(array)
        raise ArgumentError.new("#{self} requires an Array") unless array.kind_of?(Array)
        array.to_json
      end

      def decode(str)
        ActiveSupport::JSON.decode(str)
      end
    end
  end
end