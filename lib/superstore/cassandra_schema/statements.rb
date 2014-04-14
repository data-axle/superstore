module Superstore
  module Statements
    DEFAULT_CREATE_KEYSPACE = {
      'strategy_class' => 'SimpleStrategy',
      'strategy_options:replication_factor' => 1
    }

    def create_keyspace(keyspace, options = nil)
      stmt = "CREATE KEYSPACE #{keyspace}"

      options ||= DEFAULT_CREATE_KEYSPACE

      system_execute adapter.statement_with_options(stmt, options)
    end

    def drop_keyspace(keyspace)
      system_execute "DROP KEYSPACE #{keyspace}"
    end

    def create_column_family(column_family, options = {})
      create_table column_family, options
    end

    def alter_column_family(column_family, instruction, options = {})
      stmt = "ALTER TABLE #{column_family} #{instruction}"
      keyspace_execute adapter.statement_with_options(stmt, options)
    end

    def drop_column_family(column_family)
      drop_table column_family
    end

    def add_index(column_family, column, index_name = nil)
      stmt = "CREATE INDEX #{index_name.nil? ? '' : index_name} ON #{column_family} (#{column})"
      keyspace_execute stmt
    end

    # If the index was not given a name during creation, the index name is <columnfamily_name>_<column_name>_idx.
    def drop_index(index_name)
      keyspace_execute "DROP INDEX #{index_name}"
    end


    def keyspace_execute(cql)
      adapter.schema_execute cql, Superstore::Base.config[:keyspace]
    end

    def system_execute(cql)
      adapter.schema_execute cql, 'system'
    end
  end
end