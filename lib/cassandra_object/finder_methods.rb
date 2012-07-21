module CassandraObject
  module FinderMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def find(ids)
        if ids.is_a?(Array)
          find_some(ids)
        else
          find_one(ids)
        end
      end

      def find_by_id(ids)
        find(ids)
      rescue CassandraObject::RecordNotFound
        nil
      end

      def all(options = {})
        limit = options[:limit] || 100
        results = ActiveSupport::Notifications.instrument("get_range.cassandra_object", column_family: column_family, key_count: limit) do
          connection.get_range(column_family, key_count: limit, consistency: thrift_read_consistency, count: 500)
        end

        results.map do |k, v|
          v.empty? ? nil : instantiate(k, v)
        end.compact
      end

      def first(options = {})
        all(options.merge(limit: 1)).first
      end

      def count
        connection.count_range(column_family)
      end

      private
      
      def find_one(id)
        if id.blank?
          raise CassandraObject::RecordNotFound, "Couldn't find #{self.name} with key #{id.inspect}"
        elsif attributes = connection.get(column_family, id, {:count => 500}).presence
          instantiate(id, attributes)
        else
          raise CassandraObject::RecordNotFound
        end
      end

      def find_some(ids)
        ids = ids.flatten
        return ids if ids.empty?

        ids = ids.compact.map(&:to_s).uniq

        multi_get(ids).values.compact
      end

      def multi_get(keys, options={})
        attribute_results = ActiveSupport::Notifications.instrument("multi_get.cassandra_object", column_family: column_family, keys: keys) do
          connection.multi_get(column_family, keys.map(&:to_s), consistency: thrift_read_consistency, count: 500)
        end

        Hash[attribute_results.map do |key, attributes|
          [key, attributes.present? ? instantiate(key, attributes) : nil]
        end]
      end
    end
  end
end