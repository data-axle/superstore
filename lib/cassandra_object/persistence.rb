module CassandraObject
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def remove(id)
        execute_batchable_cql "DELETE FROM #{column_family}#{write_option_string} WHERE KEY = ?", id
      end

      def delete_all
        execute_cql "TRUNCATE #{column_family}"
      end

      def create(attributes = {}, &block)
        new(attributes, &block).tap do |object|
          object.save
        end
      end

      def write(id, attributes)
        if (encoded = encode_attributes(attributes)).any?
          insert_attributes = {'KEY' => id}.update encode_attributes(attributes)
          statement = "INSERT INTO #{column_family} (#{quote_columns(insert_attributes.keys) * ','}) VALUES (#{Array.new(insert_attributes.size, '?') * ','})#{write_option_string}"
          execute_batchable_cql statement, *insert_attributes.values
        end

        if (nil_attributes = attributes.select { |key, value| value.nil? }).any?
          execute_batchable_cql "DELETE #{quote_columns(nil_attributes.keys) * ','} FROM #{column_family}#{write_option_string} WHERE KEY = ?", id
        end
      end

      def batching?
        !@batch.nil?
      end

      def batch
        @batch = []
        yield
        execute_cql(batch_statement) if @batch.any?
      ensure
        @batch = nil
      end

      def instantiate(id, attributes)
        allocate.tap do |object|
          object.instance_variable_set("@id", id) if id
          object.instance_variable_set("@new_record", false)
          object.instance_variable_set("@destroyed", false)
          object.instance_variable_set("@attributes", typecast_attributes(object, attributes))
        end
      end

      def encode_attributes(attributes)
        encoded = {}
        attributes.each do |column_name, value|
          unless value.nil?
            encoded[column_name.to_s] = attribute_definitions[column_name.to_sym].coder.encode(value)
          end
        end
        encoded
      end

      private

        def quote_columns(column_names)
          column_names.map { |name| "'#{name}'" }
        end

        def batch_statement
          return nil unless @batch.any?

          [
            "BEGIN BATCH#{write_option_string(true)}",
            @batch * "\n",
            'APPLY BATCH'
          ] * "\n"
        end

        def execute_batchable_cql(cql_string, *bind_vars)
          if @batch
            @batch << CassandraCQL::Statement.sanitize(cql_string, bind_vars)
          else
            execute_cql cql_string, *bind_vars
          end
        end

        def typecast_attributes(object, attributes)
          attributes = attributes.symbolize_keys
          Hash[attribute_definitions.map { |k, attribute_definition| [k.to_s, attribute_definition.instantiate(object, attributes[k])] }]
        end

        def write_option_string(ignore_batching = false)
          if (ignore_batching || !batching?) && base_class.default_consistency
            " USING CONSISTENCY #{base_class.default_consistency}"
          end
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
      freeze
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
      @attributes.update(self.class.find(id).instance_variable_get('@attributes'))
      self
    end

    private
      def update
        write
      end

      def create
        @new_record = false
        write
      end

      def write
        changed_attributes = Hash[changed.map { |attr| [attr, read_attribute(attr)] }]
        self.class.write(id, changed_attributes)
      end
  end
end
