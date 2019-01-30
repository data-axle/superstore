module Superstore
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def find_by_id(id)
        find_by(id: id)
      end

      def delete(ids)
        adapter.delete table_name, ids
      end

      def insert_record(id, attributes)
        adapter.insert table_name, id, encode_attributes(attributes)
      end

      def update_record(id, attributes)
        adapter.update table_name, id, encode_attributes(attributes)
      end

      def instantiate(attributes, column_types = {}, &block)
        allocate.tap do |object|
          object.instance_variable_set("@id", attributes['id']) if attributes['id']
          object.instance_variable_set("@new_record", false)
          object.instance_variable_set("@destroyed", false)

          if attributes['document'].is_a?(String)
            document = JSON.parse(attributes['document'])
          else
            document = attributes
          end

          object.instance_variable_set("@attributes", decode_persisted_attributes(document))
          object.instance_variable_set("@association_cache", {})
          object.instance_variable_set("@_start_transaction_state", {})
          object.instance_variable_set("@transaction_state", nil)
        end
      end

      def encode_attributes(attributes)
        encoded = {}
        attributes.each do |column_name, value|
          encoded[column_name] = attribute_definitions[column_name].encode(value)
        end
        encoded
      end

      private

        def decode_persisted_attributes(attributes)
          result = FakeAttributeSet.new

          attributes.each do |key, value|
            if definition = attribute_definitions[key]
              result[key] = definition.decode(value)
            end
          end

          result
        end
    end

    private

      def _create_record
        write :insert_record
      end

      def _update_record(*args)
        write :update_record
      end

      def write(method)
        @new_record = false
        self.class.send(method, id, unapplied_changes)
      end
  end
end
