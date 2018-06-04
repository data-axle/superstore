module Superstore
  module Types
    class IntegerType < BaseType
      def typecast(value)
        Integer(value) rescue nil
      end
    end
  end
end
