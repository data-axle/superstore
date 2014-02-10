module CassandraObject
  module ConnectionAdapters
    class HstoreAdapter < AbstractAdapter
      def primary_key_column
        'id'
      end

      def connection
        @connection ||= ActiveRecord::Base.postgresql_connection(configuration)
      end

      def execute(statement)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          connection.exec_query statement
        end
      end

      def select(statement)
        connection.execute(statement).each do |attributes|
          yield attributes[primary_key_column], attributes['attribute_store']
        end
      end

      def build_query(scope)
        QueryBuilder.new(self, scope).to_query
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
        statement = "DELETE FROM #{table} WHERE "
        statement += ids.is_a?(Array) ? "#{primary_key_column} IN (?)" : "#{primary_key_column} = ?"

        execute_batchable sanitize(statement, ids)
      end

      def execute_batch(statements)
        stmt = [
          "BEGIN",
          statements * ";\n",
          'COMMIT'
        ] * ";\n"

        execute stmt
      end
    end
  end
end