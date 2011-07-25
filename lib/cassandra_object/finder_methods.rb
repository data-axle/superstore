module CassandraObject
  module FinderMethods
    extend ActiveSupport::Concern
    module ClassMethods
      def all(keyrange = ''..'', options = {})
        options = {:consistency => self.read_consistency, :limit => 100}.merge(options)
        count = options[:limit]
        results = ActiveSupport::Notifications.instrument("get_range.cassandra_object", column_family: column_family, start_key: keyrange.first, finish_key: keyrange.last, key_count: count) do
          connection.get_range(column_family, start: keyrange.first, finish: keyrange.last, key_count: count, consistency: consistency_for_thrift(options[:consistency]))
        end

        results.map do |k, v|
          v.empty? ? nil : instantiate(k, v)
        end.compact
      end

      # def find()
        
      # end

      def first(keyrange = ''..'', options = {})
        all(keyrange, options.merge(:limit => 1)).first
      end

      def find_with_ids(*ids)
        expects_array = ids.first.kind_of?(Array)
        return ids.first if expects_array && ids.first.empty?

        ids = ids.dup
        ids.flatten!
        ids.compact!
        ids.collect!(&:to_s)
        ids.uniq!

        #raise RecordNotFound, "Couldn't find #{record_klass.name} without an ID" if ids.empty?

        results = multi_get(ids).values.compact

        results.size <= 1 && !expects_array ? results.first : results
      end

      private
        def multi_get(keys, options={})
          options = options.reverse_merge(consistency: self.read_consistency)
          unless valid_read_consistency_level?(options[:consistency])
            raise ArgumentError, "Invalid read consistency level: '#{options[:consistency]}'. Valid options are [:quorum, :one]"
          end

          attribute_results = ActiveSupport::Notifications.instrument("multi_get.cassandra_object", column_family: column_family, keys: keys) do
            connection.multi_get(column_family, keys.map(&:to_s), consistency: consistency_for_thrift(options[:consistency]))
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

        def get(key, options={})
          multi_get([key], options).values.first
        end
    end
  end
end