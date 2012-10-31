require 'cassandra_object/schema/tasks'

module CassandraObject
  class Schema
    extend Tasks

    class << self
      DEFAULT_CREATE_KEYSPACE = {
        'strategy_class' => 'SimpleStrategy',
        'strategy_options:replication_factor' => 1
      }

      def create_keyspace(keyspace, options = {})
        stmt = "CREATE KEYSPACE #{keyspace}"

        if options.empty?
          options = DEFAULT_CREATE_KEYSPACE
        end

        system_execute statement_with_options(stmt, options)
      end

      def drop_keyspace(keyspace)
        system_execute "DROP KEYSPACE #{keyspace}"
      end

      def create_column_family(column_family, options = {})
        stmt = "CREATE COLUMNFAMILY #{column_family} " +
               "(KEY varchar PRIMARY KEY)"

        execute statement_with_options(stmt, options)
      end

      def alter_column_family_with(with)
        execute "ALTER TABLE users WITH #{with}"
      end

      def add_index()
      end

      private
        def statement_with_options(stmt, options)
          if options.any?
            with_stmt = options.map do |k,v|
              "#{k} = #{CassandraCQL::Statement.quote(v)}"
            end.join(' AND ')

            stmt << " WITH #{with_stmt}"
          end

          stmt
        end
      
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
