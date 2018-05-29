module Superstore
  module Types
    class IntegerType < BaseType
      def decode(str)
        str.to_i unless str.empty?
      end

      def typecast(value)
        value.to_i
      end
    end
  end
end
