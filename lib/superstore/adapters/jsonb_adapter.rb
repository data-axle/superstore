gem 'pg'
require 'pg'

module Superstore
  module Adapters
    class JsonbAdapter < AbstractAdapter
      Column = Struct.new(:name)
      attr_reader :superstore_column

      def initialize(superstore_column:)
        @superstore_column = superstore_column
      end

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

        statement = Arel::InsertManager.new
        statement.into(Arel::Table.new(table))
        statement.values = Arel::Nodes::ValuesList.new([[id, to_quoted_jsonb(not_nil_attributes)]])

        execute statement.to_sql
      end

      def update(table, id, attributes)
        return if attributes.empty?

        nil_properties = attributes.each_key.select { |k| attributes[k].nil? }
        not_nil_attributes = attributes.reject { |key, value| value.nil? }

        statement = Arel::UpdateManager.new
        statement.table(Arel::Table.new(table))
        statement.where(Arel::Nodes::SqlLiteral.new(primary_key_column).eq(id))

        value_update = superstore_column
        nil_properties.each do |property|
          value_update = "(#{value_update} - '#{property}')"
        end

        if not_nil_attributes.any?
          value_update = "(#{value_update} || #{quote(to_quoted_jsonb(not_nil_attributes))})"
        end

        statement.set(Column.new(superstore_column) => Arel::Nodes::SqlLiteral.new(value_update))

        execute statement.to_sql
      end

      def delete(table, ids)
        statement = Arel::DeleteManager.new
        statement.from(Arel::Table.new(table))
        statement.where(Arel::Nodes::SqlLiteral.new(primary_key_column).in(Array.wrap(id)))

        execute statement.to_sql
      end

      def quote(value)
        connection.quote(value)
      end

      def to_quoted_jsonb(data)
        ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Jsonb.new.serialize(data)
      end
    end
  end
end
