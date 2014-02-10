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

      class QueryBuilder
        def initialize(adapter, scope)
          @adapter  = adapter
          @scope    = scope
        end

        def to_query
          [
            "SELECT #{select_string} FROM #{@scope.klass.column_family}",
            where_string,
            order_string,
            limit_string,
          ].delete_if(&:blank?) * ' '
        end

        def select_string
          if @scope.select_values.any?
            quoted_fields = @scope.select_values.map { |field| "'#{field}'" }.join(',')
            "id, slice(attribute_store, ARRAY[#{quoted_fields}]) as attribute_store"
          else
            '*'
          end
        end

        def where_string
          wheres = @scope.where_values.dup
          if @scope.id_values.any?
            wheres << @adapter.create_ids_where_clause(@scope.id_values)
          end

          if wheres.any?
            "WHERE #{wheres * ' AND '}"
          end
        end

        def order_string
          if @scope.id_values.many?
            @scope.id_values.map { |id| "ID=#{@adapter.quote(id)} DESC" }.join(',')
          end
        end

        def limit_string
          if @scope.limit_value
            "LIMIT #{@scope.limit_value}"
          end
        end
      end

      INSERT_SQL = 'insert into places_tmp (id, attribute_store) values ($1, $2)'
      def write(table, id, attributes)
        if (not_nil_attributes = attributes.reject { |key, value| value.nil? }).any?
          statement = "INSERT INTO #{table} (id, attribute_store) VALUES ('#{id}', #{attributes_to_hstore(not_nil_attributes)})"
          execute_batchable statement
        end

        if (nil_attributes = attributes.select { |key, value| value.nil? }).any?
        end
      end

      def delete(table, ids)
        statement = "DELETE FROM #{table} WHERE #{create_ids_where_clause(ids)}"

        execute_batchable statement
      end

      def execute_batch(statements)
        stmt = [
          "BEGIN",
          statements * ";\n",
          'COMMIT'
        ] * ";\n"

        execute stmt
      end

      def create_ids_where_clause(ids)
        ids = ids.first if ids.is_a?(Array) && ids.one?

        if ids.is_a?(Array)
          id_list = ids.map { |id| quote(id) }.join(',')
          "#{primary_key_column} IN (#{id_list})"
        else
          "#{primary_key_column} = #{quote(ids)}"
        end
      end

      def quote(value)
        connection.quote(value)
      end

      private

        def attributes_to_hstore(attributes)
          ConnectionAdapters::PostgreSQLColumn.hstore_to_string(attributes)
        end
    end
  end
end