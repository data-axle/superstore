module CassandraObject
  class Types
    module HashType
      def encode(hash)
        raise ArgumentError.new("#{self} requires a Hash") unless hash.kind_of?(Hash)
        ActiveSupport::JSON.encode(hash)
      end
      module_function :encode

      def decode(str)
        ActiveSupport::JSON.decode(str)
      end
      module_function :decode
    end
  end
end