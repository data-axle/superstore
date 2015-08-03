gem 'pg'
require 'pg'

module Superstore
  module Adapters
    class JsonbAdapter < AbstractAdapter
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
            "id, jsonb_slice(document, #{@adapter.fields_to_postgres_array(@scope.select_values)}) as document"
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
        active_record_klass.connection
      end

      def active_record_klass=(klass)
        @active_record_klass = klass
      end

      def active_record_klass
        @active_record_klass ||= ActiveRecord::Base
      end

      def execute(statement)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          connection.execute statement
        end
      end

      def select(scope)
        statement = QueryBuilder.new(self, scope).to_query

        connection.execute(statement).each do |result|
          yield result[primary_key_column], Oj.compat_load(result['document'])
        end
      end

      def scroll(scope, batch_size)
        statement   = QueryBuilder.new(self, scope).to_query
        cursor_name = "cursor_#{SecureRandom.hex(6)}"
        fetch_sql   = "FETCH FORWARD #{batch_size} FROM #{cursor_name}"

        connection.transaction do
          connection.execute "DECLARE #{cursor_name} NO SCROLL CURSOR FOR (#{statement})"

          while (batch = connection.execute(fetch_sql)).any?
            batch.each do |result|
              yield result[primary_key_column], Oj.compat_load(result['document'])
            end
          end
        end
      end

      def insert(table, id, attributes)
        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        statement = "INSERT INTO #{table} (#{primary_key_column}, document) VALUES (#{quote(id)}, #{to_quoted_jsonb(not_nil_attributes)})"
        execute_batchable statement
      end

      def update(table, id, attributes)
        return if attributes.empty?

        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        nil_attributes = attributes.select { |key, value| value.nil? }

        if not_nil_attributes.any? && nil_attributes.any?
          value_update = "jsonb_merge(jsonb_delete(document, #{fields_to_postgres_array(nil_attributes.keys)}), #{to_quoted_jsonb(not_nil_attributes)})"
        elsif not_nil_attributes.any?
          value_update = "jsonb_merge(document, #{to_quoted_jsonb(not_nil_attributes)})"
        elsif nil_attributes.any?
          value_update = "jsonb_delete(document, #{fields_to_postgres_array(nil_attributes.keys)})"
        end

        statement = "UPDATE #{table} SET document = #{value_update} WHERE #{primary_key_column} = #{quote(id)}"
        execute_batchable statement
      end

      def delete(table, ids)
        statement = "DELETE FROM #{table} WHERE #{create_ids_where_clause(ids)}"

        execute_batchable statement
      end

      def execute_batch(statements)
        connection.transaction do
          execute(statements * ";\n")
        end
      end

      def create_table(table_name, options = {})
        ActiveRecord::Migration.create_table table_name, id: false do |t|
          t.string :id, null: false
          t.jsonb :document, null: false
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
        quoted_fields = fields.map { |field| quote(field) }.join(',')
        "ARRAY[#{quoted_fields}]"
      end

      OJ_OPTIONS = {mode: :compat}
      def to_quoted_jsonb(data)
        "#{quote(Oj.dump(data, OJ_OPTIONS))}::JSONB"
      end

      JSON_FUNCTIONS = {
        # SELECT jsonb_slice('{"b": 2, "c": 3, "a": 4}', '{b, c}');
        'jsonb_slice(data jsonb, keys text[])' => %{
          SELECT json_object_agg(key, value)::jsonb
          FROM (
            SELECT * FROM jsonb_each(data)
          ) t
          WHERE key =ANY(keys);
        },

        # SELECT jsonb_merge('{"a": 1}', '{"b": 2, "c": 3, "a": 4}');
        'jsonb_merge(data jsonb, merge_data jsonb)' => %{
          SELECT json_object_agg(key, value)::jsonb
          FROM (
            WITH to_merge AS (
              SELECT * FROM jsonb_each(merge_data)
            )
            SELECT *
            FROM jsonb_each(data)
            WHERE key NOT IN (SELECT key FROM to_merge)
            UNION ALL
            SELECT * FROM to_merge
          ) t;
        },

        # SELECT jsonb_delete('{"b": 2, "c": 3, "a": 4}', '{b, c}');
        'jsonb_delete(data jsonb, keys text[])' => %{
          SELECT json_object_agg(key, value)::jsonb
          FROM (
            SELECT * FROM jsonb_each(data)
            WHERE key <>ALL(keys)
          ) t;
        },
      }
      def define_jsonb_functions!
        JSON_FUNCTIONS.each do |signature, body|
          connection.execute %{
            CREATE OR REPLACE FUNCTION public.#{signature}
            RETURNS jsonb
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