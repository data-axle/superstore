module CassandraObject
  module FinderMethods
    extend ActiveSupport::Concern
    module ClassMethods
      def all(keyrange = ''..'', options = {})
        options = {:consistency => self.read_consistency, :limit => 100}.merge(options)
        count = options[:limit]
        results = ActiveSupport::Notifications.instrument("get_range.cassandra_object", :column_family => column_family, :start_key => keyrange.first, :finish_key => keyrange.last, :key_count => count) do
          connection.get_range(column_family, :start => keyrange.first, :finish => keyrange.last, :key_count => count, :consistency => consistency_for_thrift(options[:consistency]))
        end

        #get_ranges response changed in cassandra gem 0.11.3 for cassandra 0.8.1, now similar to other method responses like multi_get
        results.map do |k, v|
          if v.empty?
            nil
          else
            instantiate(k, v)
          end
        end.compact
      end

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
    end
  end
end