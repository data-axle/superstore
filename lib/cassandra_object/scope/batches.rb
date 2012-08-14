module CassandraObject
  class Scope
    module Batches
      def find_each(options = {})
        find_in_batches(options) do |records|
          records.each { |record| yield record }
        end
      end

      def find_in_batches(options = {})
        batch_size = options.delete(:batch_size) || 1000
        start_key = nil

        scope = limit(batch_size + 1)
        records = scope.to_a

        while records.any?
          if records.size > batch_size
            next_record = records.pop
          else
             next_record = nil
          end

          yield records
          break if next_record.nil?

          records = scope.where("KEY >= #{next_record.id}").to_a
        end
      end
    end
  end
end