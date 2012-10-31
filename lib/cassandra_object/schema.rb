require 'cassandra_object/schema/tasks'

module CassandraObject
  class Schema
    extend Tasks

    class << self
      def create_keyspace(keyspace)
        system_execute "CREATE KEYSPACE #{keyspace} " +
                       "WITH strategy_class = SimpleStrategy " +
                       " AND strategy_options:replication_factor = 1"
      end

      def drop_keyspace(keyspace)
        system_execute "DROP KEYSPACE #{keyspace}"
      end

      def create_column_family(column_family, options = {})
        stmt = "CREATE COLUMNFAMILY #{column_family} " +
               "(KEY varchar PRIMARY KEY)"

        if options.any?
          with_stmt = options.map do |k,v|
            "#{k} = #{CassandraCQL::Statement.quote(v)}"
          end.join(' AND ')
          stmt << " WITH #{with_stmt}"
        end

        execute stmt
      end

      def alter_column_family_with(with)
        execute "ALTER TABLE users WITH #{with}"
      end

      def add_index()
      end

      private
        def execute(cql)
          CassandraObject::Base.execute_cql cql
        end

        def system_execute(cql)
          @system_cql ||= CassandraCQL::Database.new(CassandraObject::Base.config.servers, keyspace: 'system')
          @system_cql.execute cql
        end
    end
  end
end
