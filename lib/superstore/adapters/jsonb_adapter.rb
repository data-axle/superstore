gem 'pg'
require 'pg'

module Superstore
  module Adapters
    class JsonbAdapter < AbstractAdapter
      PRIMARY_KEY_COLUMN = 'id'.freeze
      def primary_key_column
        PRIMARY_KEY_COLUMN
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
        connection.execute statement
      end

      def insert(table, id, attributes)
        not_nil_attributes = attributes.reject { |key, value| value.nil? }
        statement = "INSERT INTO #{table} (#{primary_key_column}, document) VALUES (#{quote(id)}, #{to_quoted_jsonb(not_nil_attributes)})"
        execute statement
      end

      def update(table, id, attributes)
        return if attributes.empty?

        nil_properties = attributes.each_key.select { |k| attributes[k].nil? }
        not_nil_attributes = attributes.reject { |key, value| value.nil? }

        value_update = "document"
        nil_properties.each do |property|
          value_update = "(#{value_update} - '#{property}')"
        end

        if not_nil_attributes.any?
          value_update = "(#{value_update} || #{to_quoted_jsonb(not_nil_attributes)})"
        end

        statement = "UPDATE #{table} SET document = #{value_update} WHERE #{primary_key_column} = #{quote(id)}"

        execute statement
      end

      def delete(table, ids)
        statement = "DELETE FROM #{table} WHERE #{create_ids_where_clause(ids)}"

        execute statement
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

      def to_quoted_jsonb(data)
        "#{quote(JSON.generate(data))}::JSONB"
      end
    end
  end
end
