module Superstore
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def find_by_id(id)
        find_by(id: id)
      end

      def _insert_record(attributes)
        id = attributes.fetch(primary_key)

        adapter.insert table_name, id, serialize_attributes(attributes)
      end

      def _update_record(attributes, constraints)
        id = constraints.fetch(primary_key)

        adapter.update table_name, id, serialize_attributes(attributes)
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

        def instantiate_instance_of(klass, attributes, column_types = {}, &block)
          if attributes[superstore_column].is_a?(String)
            attributes = JSON.parse(attributes[superstore_column]).merge('id' => attributes['id'])
          end
          attributes.each_key { |k, v| attributes.delete(k) unless attribute_types.key?(k) }

          if inheritance_column && attribute_types.key?(inheritance_column)
            klass = find_sti_class(attributes[inheritance_column])
          end

          super(klass, attributes, column_types, &block)
        end

        def adapter
          @adapter ||= Superstore::Adapters::JsonbAdapter.new
        end
    end
  end
end
