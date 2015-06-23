module Superstore
  module Types
    class FloatType < BaseType
      def encode(float)
        if model.config[:adapter] == 'jsonb'
          Float(float)
        else
          Float(float).to_s
        end
      end

      def decode(str)
        return nil if str.empty?
        str.to_f
      end

      def typecast(value)
        value.to_f
      end
    end
  end
end
