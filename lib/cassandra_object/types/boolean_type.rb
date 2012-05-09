module CassandraObject
  module Types
    class BooleanType < BaseType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0', '', nil]
      VALID_VALS = TRUE_VALS + FALSE_VALS
      
      def encode(bool)
        unless VALID_VALS.include?(bool)
          raise ArgumentError.new("#{bool.inspect} is not a Boolean")
        end
        TRUE_VALS.include?(bool) ? '1' : '0'
      end

      def decode(str)
        raise ArgumentError.new("Cannot convert #{str} into a boolean") unless VALID_VALS.include?(str)
        TRUE_VALS.include?(str)
      end
    end
  end
end