module CassandraObject
  module Types
    class HashType
      def encode(hash)
        raise ArgumentError.new("#{self} requires a Hash") unless hash.kind_of?(Hash)
        ActiveSupport::JSON.encode(hash)
      end

      def decode(str)
        ActiveSupport::JSON.decode(str)
      end
    end
  end
end