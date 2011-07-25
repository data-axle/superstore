module CassandraObject
  module Types
    module BooleanType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0', '', nil]
      VALID_VALS = TRUE_VALS + FALSE_VALS
      
      def encode(bool)
        unless VALID_VALS.include?(bool)
          raise ArgumentError.new("#{self} requires a boolean")
        end
        TRUE_VALS.include?(bool) ? '1' : '0'
      end
      module_function :encode

      def decode(str)
        raise ArgumentError.new("Cannot convert #{str} into a boolean") unless VALID_VALS.include?(str)
        TRUE_VALS.include?(str)
      end
      module_function :decode
    end
  end
end