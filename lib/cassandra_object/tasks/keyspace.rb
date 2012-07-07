module CassandraObject
  module Tasks
    class Keyspace
      def self.parse(hash)
        ks = Cassandra::Keyspace.new.with_fields hash
        ks.cf_defs = []
        hash['cf_defs'].each do |cf|
          ks.cf_defs << Cassandra::ColumnFamily.new.with_fields(cf)
        end
        ks
      end

      def exists?(name)
        connection.keyspaces.include? name.to_s
      end

      def create(name, options = {})
        keyspace = Cassandra::Keyspace.new.tap do |keyspace|
          keyspace.name           = name.to_s
          keyspace.strategy_class = options[:strategy_class] || 'org.apache.cassandra.locator.SimpleStrategy'
          keyspace.replication_factor = options[:replication_factor] || 1
          keyspace.cf_defs        = options[:cf_defs] || []
        end

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

      def schema_dump
        connection.schema
      end

      def schema_load(schema)
        connection.schema.cf_defs.each do |cf|
          connection.drop_column_family cf.name
        end

        keyspace = get
        schema.cf_defs.each do |cf|
          cf.keyspace = keyspace
          connection.add_column_family cf
        end
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
