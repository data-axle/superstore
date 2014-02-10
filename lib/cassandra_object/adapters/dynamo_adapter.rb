module CassandraObject
  module Adapters
    class DynamoAdapter < AbstractAdapter
      def primary_key_column
        'id'
      end

      def connection
        # self.namespace = spec[:namespace]
        @connection ||= AWS::DynamoDB.new(
          access_key_id: spec[:access_key_id],
          secret_access_key: spec[:secret_access_key]
        )
      end

      def select(scope)
        dynamo_table.items[key_string].attributes.to_h
        dynamo_table.batch_get(:all, keys.map(&:to_s))
      end

      def insert(table, id, attributes)
        attributes = {primary_key => id}.update(attributes)
        self.class.dynamo_table.items.create(attributes)
      end

      def update(table, id, attributes)
        dynamo_db_item = self.class.dynamo_table.items[id]

        dynamo_db_item.attributes.update do |u|
          attributes.each do |attr, value|
            if value.nil?
              u.delete(attr)
            else
              u.set(attr => value)
            end
          end
        end
      end

      def delete(table, ids)
        ids.each do |id|
          dynamo_table.items[id].delete
        end
      end

      def dynamo_table_name
        "#{namespace}.#{column_family.underscore}"
      end

      def dynamo_table
        @dynamo_table ||= begin
          table = connection.tables[dynamo_table_name]
          table.hash_key = [:id, :number]
          table
        end
      end
    end
  end
end