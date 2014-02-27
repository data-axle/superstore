require 'cassandra_object/schema/tasks'

module CassandraObject
  class Schema
    extend Tasks

    class << self
      DEFAULT_CREATE_KEYSPACE = {
        'strategy_class' => 'SimpleStrategy',
        'strategy_options:replication_factor' => 1
      }

      def create_keyspace(keyspace, options = nil)
        stmt = "CREATE KEYSPACE #{keyspace}"

        options ||= DEFAULT_CREATE_KEYSPACE

        system_execute statement_with_options(stmt, options)
      end

      def drop_keyspace(keyspace)
        system_execute "DROP KEYSPACE #{keyspace}"
      end

      def create_column_family(column_family, options = {})
        create_table column_family, options
      end

      def create_table(table_name, options = {})
        stmt = "CREATE COLUMNFAMILY #{table_name} " +
               "(KEY varchar PRIMARY KEY)"

        keyspace_execute statement_with_options(stmt, options)
      end

      def alter_column_family(column_family, instruction, options = {})
        stmt = "ALTER TABLE #{column_family} #{instruction}"
        keyspace_execute statement_with_options(stmt, options)
      end

      def drop_column_family(column_family)
        keyspace_execute "DROP TABLE #{column_family}"
      end

      def add_index(column_family, column, index_name = nil)
        stmt = "CREATE INDEX #{index_name.nil? ? '' : index_name} ON #{column_family} (#{column})"
        keyspace_execute stmt
      end

      # If the index was not given a name during creation, the index name is <columnfamily_name>_<column_name>_idx.
      def drop_index(index_name)
        keyspace_execute "DROP INDEX #{index_name}"
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

        def db
          @db ||= CassandraCQL::Database.new(CassandraObject::Base.adapter.servers, {keyspace: 'system'}, {connect_timeout: 30, timeout: 30})
        end

        def keyspace_execute(cql)
          db.execute "USE #{CassandraObject::Base.config[:keyspace]}"
          db.execute cql
        end

        def system_execute(cql)
          db.execute "USE system"
          db.execute cql
        end
    end
  end
end
