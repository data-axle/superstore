module Superstore
  module Persistence
    extend ActiveSupport::Concern

    included do
      class_attribute :batch_statements
    end

    module ClassMethods
      def delete(ids)
        adapter.delete table_name, ids
      end

      def delete_all
        adapter.execute "TRUNCATE #{table_name}"
      end

      def create(attributes = {}, &block)
        new(attributes, &block).tap do |object|
          object.save
        end
      end

      def insert_record(id, attributes)
        adapter.insert table_name, id, encode_attributes(attributes)
      end

      def update_record(id, attributes)
        adapter.update table_name, id, encode_attributes(attributes)
      end

      def batching?
        adapter.batching?
      end

      def batch(&block)
        adapter.batch(&block)
      end

      def instantiate(id, attributes)
        allocate.tap do |object|
          object.instance_variable_set("@id", id) if id
          object.instance_variable_set("@new_record", false)
          object.instance_variable_set("@destroyed", false)
          object.instance_variable_set("@attributes", typecast_persisted_attributes(attributes))
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

        def quote_columns(column_names)
          column_names.map { |name| "'#{name}'" }
        end

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

    def new_record?
      @new_record
    end

    def destroyed?
      @destroyed
    end

    def persisted?
      !(new_record? || destroyed?)
    end

    def save(*)
      new_record? ? create_self : update_self
    end

    def destroy
      self.class.delete(id)
      @destroyed = true
    end

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

    def becomes(klass)
      became = klass.new
      became.instance_variable_set("@attributes", @attributes)
      became.instance_variable_set("@new_record", new_record?)
      became.instance_variable_set("@destroyed", destroyed?)
      became
    end

    def reload
      clear_associations_cache
      @attributes = self.class.find(id).instance_variable_get('@attributes')
      self
    end

    private

      def create_self
        @new_record = false
        write :insert_record
      end

      def update_self
        write :update_record
      end

      def write(method)
        self.class.send(method, id, unapplied_changes)
      end
  end
end
