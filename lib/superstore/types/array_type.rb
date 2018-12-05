module Superstore
  module Types
    class ArrayType < BaseType
      def typecast(name, value)
        raise 'Not implemented'
        value.to_a rescue nil
      end
    end
  end
end
