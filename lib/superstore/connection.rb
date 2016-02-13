module Superstore
  module Connection
    extend ActiveSupport::Concern

    module ClassMethods
      def adapter
        @adapter ||= adapter_class.new(config)
      end

      def adapter_class
        case config[:adapter]
        when nil, 'jsonb'
          Superstore::Adapters::JsonbAdapter
        else
          raise "Unknown adapter #{config[:adapter]}"
        end
      end

      def connection
        adapter.connection
      end
    end
  end
end
