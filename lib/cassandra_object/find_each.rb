module CassandraObject
  module FindEach
    extend ActiveSupport::Concern

    module ClassMethods
      def find_each(options={})
        find_in_batches(options) do |records|
          records.each { |record| yield record }
        end
        nil
      end

      def find_in_batches(options={})
        start = options[:start] || ''
        finish = options[:finish] || ''
        batch_size = options[:batch_size] || 100

        records = all(start..finish, limit: batch_size)
        while records.any?
          yield records
          records = all(records.last.key.to_s..finish, limit: batch_size+1)
          records.shift
        end
        nil
      end
    end
  end
end