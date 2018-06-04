module Superstore
  module Types
    class BooleanType < BaseType
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0']

      def typecast(value)
        if TRUE_VALS.include?(value)
          true
        elsif FALSE_VALS.include?(value)
          false
        end
      end
    end
  end
end
