module CassandraObject
  module Adapters
    class HstoreAdapter < AbstractAdapter
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
            "id, slice(attribute_store, #{@adapter.fields_to_postgres_array(@scope.select_values)}) as attribute_store"
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
            id_orders = @scope.id_values.map { |id| "ID=#{@adapter.quote(id)} DESC" }.join(',')
            "ORDER BY #{id_orders}"
          end
        end

        def limit_string
          if @scope.limit_value
            "LIMIT #{@scope.limit_value}"
          end
        end
      end

      def primary_key_column
        'id'
      end

      def connection
        # conf = {:adapter=>"postgresql", :encoding=>"unicode", :database=>"axle_place_test", :pool=>5, :username=>"postgres"}
        # @connection ||= ActiveRecord::Base.postgresql_connection(conf)
        ActiveRecord::Base.connection
      end

      def execute(statement)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          connection.exec_query statement
        end
      end

      def select(scope)
        statement = QueryBuilder.new(self, scope).to_query

        connection.execute(statement).each do |attributes|
          yield attributes[primary_key_column], hstore_to_attributes(attributes['attribute_store'])
        end
      end

      def insert(table, id, attributes)
        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        statement = "INSERT INTO #{table} (#{primary_key_column}, attribute_store) VALUES (#{quote(id)}, #{attributes_to_hstore(not_nil_attributes)})"
        execute_batchable statement
      end

      def update(table, id, attributes)
        return if attributes.empty?

        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        nil_attributes = attributes.select { |key, value| value.nil? }

        if not_nil_attributes.any? && nil_attributes.any?
          value_update = "(attribute_store - #{fields_to_postgres_array(nil_attributes.keys)}) || #{attributes_to_hstore(not_nil_attributes)}"
        elsif not_nil_attributes.any?
          value_update = "attribute_store || #{attributes_to_hstore(not_nil_attributes)}"
        elsif nil_attributes.any?
          value_update = "attribute_store - #{fields_to_postgres_array(nil_attributes.keys)}"
        end

        statement = "UPDATE #{table} SET attribute_store = #{value_update} WHERE #{primary_key_column} = #{quote(id)}"
        execute_batchable statement
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

      def create_table(table_name, options = {})
        connection.execute 'CREATE EXTENSION IF NOT EXISTS hstore'
        ActiveRecord::Migration.create_table table_name, id: false do |t|
          t.string :id, null: false
          t.hstore :attribute_store, null: false
        end
        connection.execute "ALTER TABLE #{table_name} ADD CONSTRAINT #{table_name}_pkey PRIMARY KEY (id)"
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

      def fields_to_postgres_array(fields)
        quoted_fields = fields.map { |field| "'#{field}'" }.join(',')
        "ARRAY[#{quoted_fields}]"
      end

      private

        def attributes_to_hstore(attributes)
          quote ActiveRecord::ConnectionAdapters::PostgreSQLColumn.hstore_to_string(attributes)
        end

        def hstore_to_attributes(string)
          ActiveRecord::ConnectionAdapters::PostgreSQLColumn.string_to_hstore(string)
        end
    end
  end
end