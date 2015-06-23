module Superstore
  module Types
    class IntegerType < BaseType
      REGEX = /\A[-+]?\d+\Z/
      def encode(int)
        if model.config[:adapter] == 'jsonb'
          Integer(int)
        else
          Integer(int).to_s
        end
      end

      def decode(str)
        return nil if str.empty?
        str.to_i
      end

      def typecast(value)
        value.to_i
      end
    end
  end
end
