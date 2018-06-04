module Superstore
  module Types
    class ArrayType < BaseType
      def typecast(value)
        value.to_a rescue nil
      end
    end
  end
end
