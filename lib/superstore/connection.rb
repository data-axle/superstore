module Superstore
  module Connection
    extend ActiveSupport::Concern

    module ClassMethods
      def adapter
        @adapter ||= Superstore::Adapters::JsonbAdapter.new
      end

      def connection
        adapter.connection
      end
    end
  end
end
