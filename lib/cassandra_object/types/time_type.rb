module CassandraObject
  class Types
    module TimeType
      # lifted from the implementation of Time.xmlschema and simplified
      REGEX = /\A\s*
                (-?\d+)-(\d\d)-(\d\d)
                T
                (\d\d):(\d\d):(\d\d)
                (\.\d*)?
                (Z|[+-]\d\d:\d\d)?
                \s*\z/ix

      def encode(time)
        raise ArgumentError.new("#{self} requires a Time") unless time.kind_of?(Time)
        time.xmlschema(6)
      end
      module_function :encode

      def decode(str)
        return nil if str.empty?
        raise ArgumentError.new("Cannot convert #{str} into a Time") unless str.kind_of?(String) && str.match(REGEX)
        Time.xmlschema(str)
      end
      module_function :decode
    end
  end
end