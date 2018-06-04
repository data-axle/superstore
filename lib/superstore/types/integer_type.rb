module Superstore
  module Types
    class IntegerType < BaseType
      def typecast(value)
        value.to_i if value.present? && value.respond_to?(:to_i)
      end
    end
  end
end
