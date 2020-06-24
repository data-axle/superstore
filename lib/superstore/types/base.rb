module Superstore
  module Types
    class Base < ActiveModel::Type::Value
      def type
        self.class.name.demodulize.sub(/Type$/, '').underscore
      end
    end
  end
end
