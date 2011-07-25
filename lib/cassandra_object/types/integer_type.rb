module CassandraObject
  class Types
    module IntegerType
      REGEX = /\A[-+]?\d+\Z/
      def encode(int)
        raise ArgumentError.new("#{self} requires an Integer. You passed #{int.inspect}") unless int.kind_of?(Integer)
        int.to_s
      end
      module_function :encode

      def decode(str)
        return nil if str.empty?
        raise ArgumentError.new("Cannot convert #{str} into an Integer") unless str.kind_of?(String) && str.match(REGEX)
        str.to_i
      end
      module_function :decode
    end
  end
end