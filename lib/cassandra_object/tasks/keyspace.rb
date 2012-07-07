module CassandraObject
  module Tasks
    class Keyspace
      def exists?(name)
        connection.keyspaces.include? name.to_s
      end

      def create(name, options = {})
        keyspace = Cassandra::Keyspace.new
        keyspace.name           = name.to_s
        keyspace.replication_factor = options[:replication_factor] || 1
        keyspace.strategy_class = options[:strategy_class] || 'org.apache.cassandra.locator.SimpleStrategy'
        keyspace.cf_defs        = options[:cf_defs] || []

        connection.add_keyspace keyspace
      end

      def drop(name)
        connection.drop_keyspace name.to_s
      end

      def set(name)
        connection.keyspace = name.to_s
      end

      def get
        connection.keyspace
      end

      def clear
        return puts 'Cannot clear system keyspace' if connection.keyspace == 'system'

        connection.clear_keyspace!
      end

      private
        def connection
          @connection ||= begin
            Cassandra.new('system', CassandraObject::Base.connection.servers)
          end
        end
    end
  end
end
