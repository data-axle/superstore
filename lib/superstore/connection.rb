module Superstore
  module Connection
    extend ActiveSupport::Concern

    module ClassMethods
      def adapter
        @@adapter ||= adapter_class.new(config)
      end

      def adapter_class
        case config[:adapter]
        when 'jsonb'
          Superstore::Adapters::JsonbAdapter
        when 'hstore'
          Superstore::Adapters::HstoreAdapter
        when nil, 'cassandra'
          Superstore::Adapters::CassandraAdapter
        else
          raise "Unknown adapter #{config[:adapter]}"
        end
      end
    end
  end
end
