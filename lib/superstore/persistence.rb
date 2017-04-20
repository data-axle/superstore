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

      def delete_all
        adapter.execute "TRUNCATE #{table_name}"
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
          document = attributes['document'].is_a?(String) ? Oj.compat_load(attributes['document']) : attributes['document']
          object.instance_variable_set("@attributes", typecast_persisted_attributes(document))
          object.instance_variable_set("@association_cache", {})
          object.instance_variable_set("@_start_transaction_state", {})
          object.instance_variable_set("@transaction_state", nil)
        end
      end

      def encode_attributes(attributes)
        encoded = {}
        attributes.each do |column_name, value|
          if value.nil?
            encoded[column_name] = nil
          else
            encoded[column_name] = attribute_definitions[column_name].type.encode(value)
          end
        end
        encoded
      end

      private

        def typecast_persisted_attributes(attributes)
          result = {}

          attributes.each do |key, value|
            if definition = attribute_definitions[key]
              result[key] = definition.instantiate(value)
            end
          end

          result
        end
    end

    # def new_record?
    #   @new_record
    # end
    #
    # def destroyed?
    #   @destroyed
    # end
    #
    # def persisted?
    #   !(new_record? || destroyed?)
    # end

    # def save(*)
    #   create_or_update
    # end

    # def destroy
    #   self.class.delete(id)
    #   @destroyed = true
    # end

    def update_attribute(name, value)
      name = name.to_s
      send("#{name}=", value)
      save(validate: false)
    end

    def update(attributes)
      self.attributes = attributes
      save
    end

    alias update_attributes update

    def update!(attributes)
      self.attributes = attributes
      save!
    end

    alias update_attributes! update!

    # def reload
    #   clear_association_cache
    #   @attributes = self.class.find(id).instance_variable_get('@attributes')
    #   self
    # end

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
