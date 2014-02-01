module CassandraObject
  module Adapters
    class CassandraAdapter < AbstractAdapter
      def cql
        @cql ||= CassandraCQL::Database.new(config.servers, {keyspace: config.keyspace}, config.thrift_options)
      end

      def execute(statement)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          cql.execute statement
        end
      end

      # def escape_where_value(value)
      #   if value.is_a?(Array)
      #     value.map { |v| escape_where_value(v) }.join(",")
      #   elsif value.is_a?(String)
      #     value = value.gsub("'", "''")
      #     "'#{value}'"
      #   else
      #     value
      #   end
      # end
      def select(table, ids, options ={})
        select_string = options[:select] ? (['KEY'] | select_values) * ',' : '*'
        where_string  = sanitize(ids.is_a?(Array) ? "KEY IN (?)" : "KEY = ?", ids)
        limit_string  = options[:limit] ? sanitize("LIMIT ?", limit[:limit]) : nil

        [
          "SELECT #{select_string} FROM #{table}",
          consistency_string,
          where_string,
          limit_string
        ].delete_if(&:blank?) * ' '
      end

      def write(table, id, attributes)
        if (not_nil_attributes = attributes.reject { |key, value| value.nil? }).any?
          insert_attributes = {'KEY' => id}.update(not_nil_attributes)
          statement = "INSERT INTO #{table} (#{quote_columns(insert_attributes.keys) * ','}) VALUES (#{Array.new(insert_attributes.size, '?') * ','})#{write_option_string}"
          execute_batchable sanitize(statement, insert_attributes.values)
        end

        if (nil_attributes = attributes.select { |key, value| value.nil? }).any?
          execute_batchable sanitize("DELETE #{quote_columns(nil_attributes.keys) * ','} FROM #{table}#{write_option_string} WHERE KEY = ?", id)
        end
      end

      def delete(table, ids)
        statement = "DELETE FROM #{table}#{write_option_string} WHERE "
        statement += ids.is_a?(Array) ? "KEY IN (?)" : "KEY = ?"

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

      private

        def sanitize(statement, bind_vars)
          CassandraCQL::Statement.sanitize(statement, Array.wrap(bind_vars))
        end

        def quote_columns(column_names)
          column_names.map { |name| "'#{name}'" }
        end

        def write_option_string(ignore_batching = false)
          if (ignore_batching || !batching?) && consistency
            " USING CONSISTENCY #{consistency}"
          end
        end

    end
  end
end
