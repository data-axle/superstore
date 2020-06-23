module Superstore
  module Types
    class Base < ActiveModel::Type::Value
      def type
        self.class.name.demodulize.sub(/Type$/, '').downcase
      end
    end
  end
end
