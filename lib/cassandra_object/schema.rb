module CassandraObject
  class Schema
    class << self
      def create_keyspace(keyspace)
        system_execute "CREATE KEYSPACE #{keyspace} " +
                       "WITH strategy_class = SimpleStrategy " +
                       " AND strategy_options:replication_factor = 1"
      end

      def drop_keyspace(keyspace)
        system_execute "DROP KEYSPACE #{keyspace}"
      end

      def create_column_family(column_family)
        execute "CREATE COLUMNFAMILY #{column_family} " +
                "(KEY varchar PRIMARY KEY)"
      end

      def alter_column_family_with(with)
        execute "ALTER TABLE users WITH #{with}"
      end

      def add_index()
        
      end

      private
        def execute(cql)
          CassandraObject::Base.cql.execute cql
        end

        def system_execute(cql)
          @system_cql ||= CassandraCQL::Database.new(CassandraObject::Base.connection_config[:servers], keyspace: 'system')
          @system_cql.execute cql
        end
    end
  end
end
