module Superstore
  module Types
    class IntegerType < BaseType
      def typecast(value)
        if value.is_a?(String)
          Integer(value, 10)
        else
          Integer(value)
        end
      rescue
      end
    end
  end
end
