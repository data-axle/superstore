module CassandraObject
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def remove(key)
        ActiveSupport::Notifications.instrument("remove.cassandra_object", column_family: column_family, key: key) do
          connection.remove(column_family, key.to_s, consistency: thrift_write_consistency)
        end
      end

      def delete_all
        ActiveSupport::Notifications.instrument("truncate.cassandra_object", column_family: column_family) do
          connection.truncate!(column_family)
        end
      end

      def create(attributes = {})
        new(attributes).tap do |object|
          object.save
        end
      end

      def write(key, attributes, schema_version)
        key.tap do |key|
          attributes = encode_columns_hash(attributes, schema_version)
          ActiveSupport::Notifications.instrument("insert.cassandra_object", column_family: column_family, key: key, attributes: attributes) do
            connection.insert(column_family, key.to_s, attributes, consistency: thrift_write_consistency)
          end
        end
      end

      def instantiate(key, attributes)
        # remove any attributes we don't know about. we would do this earlier, but we want to make such
        #  attributes available to migrations
        attributes.delete_if { |k,_| model_attributes[k].nil? }

        allocate.tap do |object|
          object.instance_variable_set("@schema_version", attributes.delete('schema_version'))
          object.instance_variable_set("@key", parse_key(key))
          object.instance_variable_set("@new_record", false)
          object.instance_variable_set("@destroyed", false)
          object.instance_variable_set("@attributes", decode_columns_hash(object, attributes))
        end
      end

      def encode_columns_hash(attributes, schema_version)
        attributes.inject({}) do |memo, (column_name, value)|
          # cassandra stores bytes, not strings, so it has no concept of encodings. The ruby thrift gem 
          # expects all strings to be encoded as ascii-8bit.
          # don't attempt to encode columns that are nil
          memo[column_name.to_s] = value.nil? ? '' : model_attributes[column_name].coder.encode(value).force_encoding('ASCII-8BIT')
          memo
        end.merge({"schema_version" => schema_version.to_s})
      end

      def decode_columns_hash(object, attributes)
        Hash[attributes.map { |k, v| [k.to_s, instantiate_attribute(object, k, v)] }]
      end
      
      def column_family_configuration
        [{:Name => column_family, :CompareWith => "UTF8Type"}]
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
      begin
        create_or_update
      rescue CassandraObject::RecordInvalid
        false
      end
    end

    def save!
      create_or_update || raise(RecordNotSaved)
    end

    def destroy
      self.class.remove(key)
      @destroyed = true
      freeze
    end

    def update_attribute(name, value)
      name = name.to_s
      send("#{name}=", value)
      save(:validate => false)
    end

    def update_attributes(attributes)
      self.attributes = attributes
      save
    end

    def update_attributes!(attributes)
      self.attributes = attributes
      save!
    end

    def reload
      @attributes.update(self.class.find(self.id).instance_variable_get('@attributes'))
    end

    private
      def create_or_update
        result = new_record? ? create : update
        result != false
      end

      def create
        @key ||= self.class.next_key(self)
        write
        @new_record = false
        @key
      end
    
      def update
        write
      end

      def write
        changed_attributes = changed.inject({}) { |h, n| h[n] = read_attribute(n); h }
        self.class.write(key, changed_attributes, schema_version)
      end
  end
end
