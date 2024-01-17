module Superstore
  module Types
    class JsonType < Base
      def serialize(value)
        value if value.present?
      end
    end
  end
end
