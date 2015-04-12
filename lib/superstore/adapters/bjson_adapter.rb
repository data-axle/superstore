gem 'pg'
require 'pg'

module Superstore
  module Adapters
    class BjsonAdapter < AbstractAdapter
      JSON_FUNCTIONS = {
        # SELECT json_slice('{"b": 2, "c": 3, "a": 4}', '{b, c}');
        'json_slice(data json, keys text[])' => %w{
          SELECT json_object_agg(key, value)
          FROM (
            SELECT * FROM json_each(data)
          ) t
          WHERE key =ANY(keys);
        },

        # SELECT json_merge('{"a": 1}', '{"b": 2, "c": 3, "a": 4}');
        'json_merge(data json, merge_data json)' => %w{
          SELECT json_object_agg(key, value)
          FROM (
            WITH to_merge AS (
              SELECT * FROM json_each(merge_data)
            )
            SELECT *
            FROM json_each(data)
            WHERE key NOT IN (SELECT key FROM to_merge)
            UNION ALL
            SELECT * FROM to_merge
          ) t;
        },

        # SELECT json_delete('{"b": 2, "c": 3, "a": 4}', '{b, c}');
        'json_delete(data json, keys text[])' => %w{
          SELECT json_object_agg(key, value)
          FROM (
            SELECT * FROM json_each(data)
            WHERE key <>ALL(keys)
          ) t;
        },
      }

      class QueryBuilder
        def initialize(adapter, scope)
          @adapter  = adapter
          @scope    = scope
        end

        def to_query
          [
            "SELECT #{select_string} FROM #{@scope.klass.table_name}",
            where_string,
            order_string,
            limit_string
          ].delete_if(&:blank?) * ' '
        end

        def select_string
          if @scope.select_values.any?
            "id, json_slice(attribute_store, #{@adapter.fields_to_postgres_array(@scope.select_values)}) as attribute_store"
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
          if @scope.order_values.any?
            orders = @scope.order_values.join(', ')
            "ORDER BY #{orders}"
          elsif @scope.id_values.many?
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
          connection.execute statement
        end
      end

      def select(scope)
        statement = QueryBuilder.new(self, scope).to_query

        connection.execute(statement).each do |attributes|
          yield attributes[primary_key_column], Oj.compat_load(attributes['attribute_store'])
        end
      end

      def insert(table, id, attributes)
        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        statement = "INSERT INTO #{table} (#{primary_key_column}, attribute_store) VALUES (#{quote(id)}, #{to_quoted_json(not_nil_attributes)})"
        execute_batchable statement
      end

      def update(table, id, attributes)
        return if attributes.empty?

        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        nil_attributes = attributes.select { |key, value| value.nil? }

        if not_nil_attributes.any? && nil_attributes.any?
          value_update = "json_merge(json_delete(attribute_store, #{fields_to_postgres_array(nil_attributes.keys)}), #{to_quoted_json(not_nil_attributes)}"
        elsif not_nil_attributes.any?
          value_update = "json_merge(attribute_store, #{to_quoted_json(not_nil_attributes)})"
        elsif nil_attributes.any?
          value_update = "json_delete(attribute_store, #{fields_to_postgres_array(nil_attributes.keys)})"
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
        define_json_functions!

        ActiveRecord::Migration.create_table table_name, id: false do |t|
          t.string :id, null: false
          t.bjson :attribute_store, null: false
        end
        connection.execute "ALTER TABLE \"#{table_name}\" ADD CONSTRAINT #{table_name}_pkey PRIMARY KEY (id)"
      end

      def drop_table(table_name)
        ActiveRecord::Migration.drop_table table_name
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

      OJ_OPTIONS = {mode: :compat}
      def to_quoted_json(data)
        "'#{Oj.dump(data, OJ_OPTIONS)}'"
      end

      def define_json_functions!
        JSON_FUNCTIONS.each do |signature, body|
          connection.execute %W{
            CREATE OR REPLACE FUNCTION public.#{signature}
            RETURNS json
            IMMUTABLE
            LANGUAGE sql
            AS $$
              #{body}
            $$;
          }
        end
      end
    end
  end
end
