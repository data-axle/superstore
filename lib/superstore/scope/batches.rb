module Superstore
  module Batches
    def find_each(options = {})
      batch_size = options[:batch_size] || 1000

      klass.adapter.scroll(self, batch_size) do |key, attributes|
        yield klass.instantiate(key, attributes)
      end
    end

    def find_in_batches(options = {})
      batch_size = options[:batch_size] || 1000
      batch = []

      find_each(options) do |record|
        batch << record

        if batch.size == batch_size
          yield batch
          batch = []
        end
      end

      yield(batch) if batch.any?
    end
  end
end
