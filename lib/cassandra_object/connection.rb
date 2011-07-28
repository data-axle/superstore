module CassandraObject
  module Connection
    class CassandraThriftClient < ThriftClient
      def connect!
        client = super
        # ThriftClient does not support hooking into the reconnect process, so we need 
        # to extend it to set the keyspace upon reconnect
        @client.set_keyspace(@options[:keyspace]) if @options[:keyspace]
        client
      end

      def keyspace=(ks)
        @options[:keyspace] = ks
      end
    end

    class RetryingCassandra < Cassandra
      def keyspace=(ks)
        super
        @client.keyspace = ks
      end

      def new_client
        @thrift_client_options[:keyspace] = @keyspace if @keyspace
        CassandraThriftClient.new(CassandraThrift::Cassandra::Client, @servers, @thrift_client_options)
      end
    end

    extend ActiveSupport::Concern
    
    included do
      class_attribute :connection
    end

    module ClassMethods
      DEFAULT_OPTIONS = {
        servers: "127.0.0.1:9160",
        thrift: {} 
      }
      def establish_connection(spec)
        spec.reverse_merge!(DEFAULT_OPTIONS)
        self.connection = RetryingCassandra.new(spec[:keyspace], spec[:servers], spec[:thrift])
      end
    end
  end
end
