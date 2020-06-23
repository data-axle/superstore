module Superstore
  module Types
    class BooleanType < Base
      TRUE_VALS = [true, 'true', '1']
      FALSE_VALS = [false, 'false', '0']

      def cast_value(value)
        if TRUE_VALS.include?(value)
          true
        elsif FALSE_VALS.include?(value)
          false
        end
      end
    end
  end
end
