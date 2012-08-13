module CassandraObject
  module Batches
    extend ActiveSupport::Concern

    module ClassMethods
      def find_each(options = {})
        find_in_batches(options) do |records|
          records.each { |record| yield record }
        end
      end

      def find_in_batches(options = {})
        batch_size = options.delete(:batch_size) || 1000
        start_key = nil

        statement = "select * from #{column_family} limit #{batch_size + 1}"
        records = instantiate_from_cql statement

        while records.any?
          if records.size > batch_size
            next_record = records.pop
          else
             next_record = nil
          end

          yield records
          break if next_record.nil?

          statement = "SELECT * FROM #{column_family} WHERE KEY >= ? LIMIT #{batch_size + 1}"
          records = instantiate_from_cql statement, next_record.id
        end
      end
    end
  end
end