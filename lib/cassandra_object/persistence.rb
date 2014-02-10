module CassandraObject
  module Persistence
    extend ActiveSupport::Concern

    included do
      class_attribute :batch_statements
    end

    module ClassMethods
      def remove(ids)
        adapter.delete column_family, ids
      end

      def delete_all
        adapter.execute "TRUNCATE #{column_family}"
      end

      def create(attributes = {}, &block)
        new(attributes, &block).tap do |object|
          object.save
        end
      end

      def insert_record(id, attributes)
        adapter.insert column_family, id, encode_attributes(attributes)
      end

      def update_record(id, attributes)
        adapter.update column_family, id, encode_attributes(attributes)
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
          object.instance_variable_set("@attributes", typecast_persisted_attributes(object, attributes))
        end
      end

      def encode_attributes(attributes)
        encoded = {}
        attributes.each do |column_name, value|
          if value.nil?
            encoded[column_name] = nil
          else
            encoded[column_name] = attribute_definitions[column_name].coder.encode(value)
          end
        end
        encoded
      end

      private

        def quote_columns(column_names)
          column_names.map { |name| "'#{name}'" }
        end

        def typecast_persisted_attributes(object, attributes)
          attributes.each do |key, value|
            if definition = attribute_definitions[key]
              attributes[key] = definition.instantiate(object, value)
            else
              attributes.delete(key)
            end
          end

          attribute_definitions.each_value do |definition|
            unless definition.default.nil? || attributes.has_key?(definition.name)
              attributes[definition.name] = definition.default
            end
          end

          attributes
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
      new_record? ? create : update
    end

    def destroy
      self.class.remove(id)
      @destroyed = true
    end

    def update_attribute(name, value)
      name = name.to_s
      send("#{name}=", value)
      save(validate: false)
    end

    def update_attributes(attributes)
      self.attributes = attributes
      save
    end

    def update_attributes!(attributes)
      self.attributes = attributes
      save!
    end

    def becomes(klass)
      became = klass.new
      became.instance_variable_set("@attributes", @attributes)
      became.instance_variable_set("@new_record", new_record?)
      became.instance_variable_set("@destroyed", destroyed?)
      became
    end

    def reload
      clear_belongs_to_cache
      @attributes = self.class.find(id).instance_variable_get('@attributes')
      self
    end

    private

      def create
        @new_record = false
        write :insert_record
      end

      def update
        write :update_record
      end

      def write(method)
        changed_attributes = Hash[changed.map { |attr| [attr, read_attribute(attr)] }]
        self.class.send(method, id, changed_attributes)
      end
  end
end
