module Superstore
  module Persistence
    extend ActiveSupport::Concern
    include ActiveRecord::Persistence

    module ClassMethods
      def find_by_id(id)
        find_by(id: id)
      end

      def _insert_record(id, attributes)
        adapter.insert table_name, id, serialize_attributes(attributes)
      end

      def _update_record(id, attributes)
        adapter.update table_name, id, serialize_attributes(attributes)
      end

      def instantiate(attributes, column_types = {}, &block)
        if attributes['document'].is_a?(String)
          attributes = JSON.parse(attributes['document']).merge('id' => attributes['id'])
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
        attributes.each_value do |attribute|
          next if attribute.name == primary_key
          serialized[attribute.name] = attribute.value_before_type_cast ? attribute.value_for_database : nil
        end
        serialized
      end
    end

    private

      def _create_record(attribute_names = self.attribute_names)
        write :_insert_record, attribute_names
      end

      def _update_record(attribute_names = self.attribute_names)
        write :_update_record, attribute_names
      end

      def write(method, attribute_names)
        result = ActiveModel::AttributeSet.new({})
        attribute_names.each { |attr| result[attr] = @attributes[attr] }

        @new_record = false
        self.class.send(method, id, result)
      end
  end
end
