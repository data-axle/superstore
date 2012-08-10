module CassandraObject
  module Connection
    extend ActiveSupport::Concern
    
    included do
      class_attribute :connection_config
    end

    module ClassMethods
      DEFAULT_OPTIONS = {
        servers: "127.0.0.1:9160",
        thrift: {}
      }

      def establish_connection(spec)
        self.connection_config = spec.reverse_merge(DEFAULT_OPTIONS)
      end

      def connection
        @@connection ||= Cassandra.new(connection_config[:keyspace], connection_config[:servers], connection_config[:thrift].symbolize_keys!)
      end

      def cql
        @@cql ||= CassandraCQL::Database.new(connection_config[:servers], keyspace: connection_config[:keyspace])
      end

      def execute_cql(cql_string, *bind_vars)
        statement = CassandraCQL::Statement.sanitize(cql_string, bind_vars)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          cql.execute statement
        end
      end
    end
  end
end
