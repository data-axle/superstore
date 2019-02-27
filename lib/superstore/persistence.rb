module Superstore
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def _insert_record(attributes)
        id = attributes.fetch(primary_key)

        adapter.insert table_name, id, serialize_attributes(attributes)
      end

      def _update_record(attributes, constraints)
        id = constraints.fetch(primary_key)

        adapter.update table_name, id, serialize_attributes(attributes)
      end

      def instantiate(attributes, column_types = {}, &block)
        if attributes[superstore_column].is_a?(String)
          attributes = JSON.parse(attributes[superstore_column]).merge('id' => attributes['id'])
        end
        attributes = attributes_builder.build_from_database(attributes, column_types)

        allocate.tap do |object|
          object.instance_variable_set("@new_record", false)
          object.instance_variable_set("@destroyed", false)

          object.instance_variable_set("@attributes", attributes)
          object.instance_variable_set("@association_cache", {})
          object.instance_variable_set("@_start_transaction_state", {})
          object.instance_variable_set("@transaction_state", nil)
        end
      end

      def serialize_attributes(attributes)
        serialized = {}
        attributes.each do |attr_name, value|
          next if attr_name == primary_key
          serialized[attr_name] = attribute_types[attr_name].serialize(value)
        end
        serialized
      end

      private

        def adapter
          @adapter ||= Superstore::Adapters::JsonbAdapter.new
        end

    end
  end
end
