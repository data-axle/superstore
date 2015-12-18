module Superstore
  module Types
    class BaseType
      attr_accessor :model, :options
      def initialize(model, options = {})
        @model   = model
        @options = options
      end

      def encode(value)
        value
      end

      def decode(str)
        str
      end

      def typecast(value)
        value
      end
    end
  end
end
