module CassandraObject
  module FinderMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def find(key)
        if !parse_key(key)
          raise CassandraObject::RecordNotFound, "Couldn't find #{self.name} with key #{key.inspect}"
        elsif attributes = connection.get(column_family, key)
          instantiate(key, attributes)
        else
          raise CassandraObject::RecordNotFound
        end
      end

      def find_by_id(key)
        find(key)
      rescue CassandraObject::RecordNotFound
        nil
      end

      def all(options = {})
        limit = options[:limit] || 100
        results = ActiveSupport::Notifications.instrument("get_range.cassandra_object", column_family: column_family, key_count: limit) do
          connection.get_range(column_family, key_count: limit, consistency: thrift_read_consistency)
        end

        results.map do |k, v|
          v.empty? ? nil : instantiate(k, v)
        end.compact
      end

      def first(options = {})
        all(options.merge(limit: 1)).first
      end

      def find_with_ids(*ids)
        ids = ids.flatten
        return ids if ids.empty?

        ids = ids.compact.map(&:to_s).uniq

        multi_get(ids).values.compact
      end

      def multi_get(keys, options={})
        attribute_results = ActiveSupport::Notifications.instrument("multi_get.cassandra_object", column_family: column_family, keys: keys) do
          connection.multi_get(column_family, keys.map(&:to_s), consistency: thrift_read_consistency)
        end

        attribute_results.inject({}) do |memo, (key, attributes)|
          if attributes.empty?
            memo[key] = nil
          else
            memo[parse_key(key)] = instantiate(key, attributes)
          end
          memo
        end
      end
    end
  end
end