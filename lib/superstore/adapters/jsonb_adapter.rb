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

      def insert(table, id, superstore_attributes, column_attributes)
        not_nil_superstore_attributes = superstore_attributes.reject { |key, value| value.nil? }

        statement = Arel::InsertManager.new(Arel::Table.new(table))
        statement.values = Arel::Nodes::ValuesList.new([[
          id.value,
          to_jsonb(not_nil_superstore_attributes),
          *column_attributes.values.map(&:value)
        ]])

        execute statement.to_sql
      end

      def update(table, id, superstore_attributes, column_attributes)
        return if superstore_attributes.empty? && column_attributes.empty?

        nil_superstore_properties = superstore_attributes.each_key.select { |k| superstore_attributes[k].nil? }
        not_nil_superstore_attributes = superstore_attributes.reject { |key, value| value.nil? }

        statement = Arel::UpdateManager.new
        statement.table(Arel::Table.new(table))
        statement.where(Arel::Nodes::SqlLiteral.new(primary_key_column).eq(id))

        value_update = superstore_column
        nil_superstore_properties.each do |property|
          value_update = "(#{value_update} - '#{property}')"
        end

        if not_nil_superstore_attributes.any?
          value_update = "(#{value_update} || #{quote(to_jsonb(not_nil_superstore_attributes))})"
        end

        values = column_attributes.merge(superstore_column => value_update)
        values.transform_keys! { |k| Column.new(k) }
        values.transform_values! { |v| Arel::Nodes::SqlLiteral.new(v) }
        statement.set(values)

        execute statement.to_sql
      end


      def quote(value)
        connection.quote(value)
      end

      def to_jsonb(data)
        ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Jsonb.new.serialize(data)
      end
    end
  end
end
