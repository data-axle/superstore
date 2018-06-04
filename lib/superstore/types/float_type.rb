module Superstore
  module Types
    class FloatType < BaseType
      def typecast(value)
        Float(value) rescue nil
      end
    end
  end
end
