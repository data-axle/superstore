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

      def alter_column_family(column_family, instruction, options = {})
        stmt = "ALTER TABLE #{column_family} #{instruction}"
        execute statement_with_options(stmt, options)
      end

      def drop_column_family(column_family)
        stmt = "DROP TABLE #{column_family}"
        execute stmt
      end

      def add_index(column_family, column, index_name = nil)
        stmt = "CREATE INDEX #{index_name.nil? ? '' : index_name} ON #{column_family} (#{column})"
        execute stmt
      end

      def drop_index(index_name)
        # If the index was not given a name during creation, the index name is <columnfamily_name>_<column_name>_idx.
        stmt = "DROP INDEX #{index_name}"
        execute stmt
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
