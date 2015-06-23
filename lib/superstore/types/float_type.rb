module Superstore
  module Types
    class FloatType < BaseType
      REGEX = /\A[-+]?\d+(\.\d+)?\Z/
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
    end
  end
end
