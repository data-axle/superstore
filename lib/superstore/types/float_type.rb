module Superstore
  module Types
    class FloatType < BaseType
      def typecast(value)
        value.to_f if value.present? && value.respond_to?(:to_f)
      end
    end
  end
end
