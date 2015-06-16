module Superstore
  module Types
    class BooleanType < BaseType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0', '', nil]
      VALID_VALS = TRUE_VALS + FALSE_VALS

      def encode(bool)
        unless VALID_VALS.include?(bool)
          raise ArgumentError.new("#{bool.inspect} is not a Boolean")
        end

        if model.config[:adapter] == 'jsonb'
          TRUE_VALS.include?(bool)
        else
          TRUE_VALS.include?(bool) ? '1' : '0'
        end
      end

      def decode(str)
        TRUE_VALS.include?(str)
      end
    end
  end
end
