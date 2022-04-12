module Superstore
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def find_by_id(id)
        find_by(id: id)
      end

      def _insert_record(attributes)
        id = attributes.fetch(primary_key)

        superstore_attributes = serialize_attributes(attributes)
        adapter.insert table_name, id, superstore_attributes, attributes.except(primary_key, *superstore_attributes.keys)
      end

      def _update_record(attributes, constraints)
        id = constraints.fetch(primary_key)

        superstore_attributes = serialize_attributes(attributes)
        adapter.update table_name, id, superstore_attributes, attributes.except(primary_key, *superstore_attributes.keys)
      end

      def serialize_attributes(attributes)
        serialized = {}
        attributes.except(primary_key).each do |attr_name, value|
          attribute_type = attribute_types[attr_name]
          next unless attribute_type.is_a?(Superstore::Types::Base)

          serialized[attr_name] = attribute_type.serialize(value)
        end
        serialized
      end

      private

        def instantiate_instance_of(klass, attributes, column_types = {}, &block)
          if attributes[superstore_column].is_a?(String)
            attributes.merge!(JSON.parse(attributes.delete(superstore_column)))
          end

          if inheritance_column && attribute_types.key?(inheritance_column)
            klass = find_sti_class(attributes[inheritance_column])
          end

          attributes.each_key { |k, v| attributes.delete(k) unless klass.attribute_types.key?(k) }

          super(klass, attributes, column_types, &block)
        end

        def adapter
          @adapter ||= Superstore::Adapters::JsonbAdapter.new(superstore_column: superstore_column)
        end
    end
  end
end
