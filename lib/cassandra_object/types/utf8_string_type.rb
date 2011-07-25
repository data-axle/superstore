module CassandraObject
  class Types
    module UTF8StringType
      def encode(str)
        # This is technically the most correct, but it is a pain to require utf-8 encoding for all strings. Should revisit.
        #raise ArgumentError.new("#{self} requires a UTF-8 encoded String") unless str.kind_of?(String) && str.encoding == Encoding::UTF_8
        raise ArgumentError.new("#{self} requires a String") unless str.kind_of?(String)
        str.dup
      end
      module_function :encode

      def decode(str)
        str.force_encoding('UTF-8')
      end
      module_function :decode
    end
  end
end