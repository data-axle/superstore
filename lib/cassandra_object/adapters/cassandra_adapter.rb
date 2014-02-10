module CassandraObject
  module Adapters
    class CassandraAdapter < AbstractAdapter
      def primary_key_column
        'KEY'
      end

      def connection
        @connection ||= CassandraCQL::Database.new(config.servers, {keyspace: config.keyspace}, config.thrift_options)
      end

      def execute(statement)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          connection.execute statement
        end
      end

      def select(statement)
        execute(statement).fetch do |cql_row|
          attributes = cql_row.to_hash
          key = attributes.delete(primary_key_column)
          yield(key, attributes) unless attributes.empty?
        end
      end

      def build_query(scope)
        QueryBuilder.new(self, scope).to_query
      end

      class QueryBuilder
        def initialize(adapter, scope)
          @adapter  = adapter
          @scope    = scope
        end

        def to_query
          [
            "SELECT #{select_string} FROM #{@scope.klass.column_family}",
            @adapter.write_option_string,
            where_string,
            limit_string
          ].delete_if(&:blank?) * ' '
        end

        def select_string
          if @scope.select_values.any?
            (['KEY'] | @scope.select_values) * ','
          else
            '*'
          end
        end

        def where_string
          if @scope.where_values.any?
            wheres = []

            @scope.where_values.map do |where_value|
              wheres.concat format_where_statement(where_value)
            end

            "WHERE #{wheres * ' AND '}"
          else
            ''
          end
        end

        def format_where_statement(where_value)
          if where_value.is_a?(String)
            [where_value]
          elsif where_value.is_a?(Hash)
            where_value.map do |column, value|
              if value.is_a?(Array)
                "#{column} IN (#{escape_where_value(value)})"
              else
                "#{column} = #{escape_where_value(value)}"
              end
            end
          end
        end

        def escape_where_value(value)
          if value.is_a?(Array)
            value.map { |v| escape_where_value(v) }.join(",")
          elsif value.is_a?(String)
            value = value.gsub("'", "''")
            "'#{value}'"
          else
            value
          end
        end

        def limit_string
          if @scope.limit_value
            "LIMIT #{@scope.limit_value}"
          else
            ""
          end
        end
      end

      def write(table, id, attributes)
        if (not_nil_attributes = attributes.reject { |key, value| value.nil? }).any?
          insert_attributes = {primary_key_column => id}.update(not_nil_attributes)
          statement = "INSERT INTO #{table} (#{quote_columns(insert_attributes.keys) * ','}) VALUES (#{Array.new(insert_attributes.size, '?') * ','})#{write_option_string}"
          execute_batchable sanitize(statement, *insert_attributes.values)
        end

        if (nil_attributes = attributes.select { |key, value| value.nil? }).any?
          execute_batchable sanitize("DELETE #{quote_columns(nil_attributes.keys) * ','} FROM #{table}#{write_option_string} WHERE #{primary_key_column} = ?", id)
        end
      end

      def delete(table, ids)
        statement = "DELETE FROM #{table}#{write_option_string} WHERE "
        statement += ids.is_a?(Array) ? "#{primary_key_column} IN (?)" : "#{primary_key_column} = ?"

        execute_batchable sanitize(statement, ids)
      end

      def execute_batch(statements)
        raise 'No can do' if statements.empty?

        stmt = [
          "BEGIN BATCH#{write_option_string(true)}",
          statements * "\n",
          'APPLY BATCH'
        ] * "\n"

        execute stmt
      end

      def consistency
        @consistency
      end

      def consistency=(val)
        @consistency = val
      end

      def write_option_string(ignore_batching = false)
        if (ignore_batching || !batching?) && consistency
          " USING CONSISTENCY #{consistency}"
        end
      end

      private

        def sanitize(statement, *bind_vars)
          CassandraCQL::Statement.sanitize(statement, bind_vars).force_encoding(Encoding::UTF_8)
        end

        def quote_columns(column_names)
          column_names.map { |name| "'#{name}'" }
        end

    end
  end
end
