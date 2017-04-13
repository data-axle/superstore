module Superstore
  module Types
    class IntegerType < BaseType
      def encode(int)
        raise ArgumentError.new("#{int.inspect} is not an Integer.") unless int.kind_of?(Integer)

        int
      end

      def decode(str)
        str.to_i unless str.empty?
      end

      def typecast(value)
        value.to_i
      end
    end
  end
end
