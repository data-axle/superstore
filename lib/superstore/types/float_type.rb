module Superstore
  module Types
    class FloatType < Base
      def cast_value(value)
        Float(value) rescue nil
      end
    end
  end
end
