module CassandraObject
  class Types
    module BooleanType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0', '', nil]
      def encode(bool)
        unless TRUE_VALS.any? { |a| bool == a } || FALSE_VALS.any? { |a| bool == a }
          raise ArgumentError.new("#{self} requires a boolean")
        end
        TRUE_VALS.include?(bool) ? '1' : '0'
      end
      module_function :encode

      def decode(str)
        raise ArgumentError.new("Cannot convert #{str} into a boolean") unless TRUE_VALS.any? { |a| str == a } || FALSE_VALS.any? { |a| str == a }
        TRUE_VALS.include?(str)
      end
      module_function :decode
    end
  end
end