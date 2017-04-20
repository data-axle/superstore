module Superstore
  module Relation
    module Scrolling
      def scroll_each(options = {})
        batch_size = options[:batch_size] || 1000

        scroll_results(batch_size) do |attributes|
          yield klass.instantiate(attributes)
        end
      end

      def scroll_in_batches(options = {})
        batch_size = options[:batch_size] || 1000
        batch = []

        scroll_each(options) do |record|
          batch << record

          if batch.size == batch_size
            yield batch
            batch = []
          end
        end

        yield(batch) if batch.any?
      end

      private
      
      def scroll_results(batch_size)
        statement   = to_sql
        cursor_name = "cursor_#{SecureRandom.hex(6)}"
        fetch_sql   = "FETCH FORWARD #{batch_size} FROM #{cursor_name}"

        connection.transaction do
          connection.execute "DECLARE #{cursor_name} NO SCROLL CURSOR FOR (#{statement})"

          while (batch = connection.execute(fetch_sql)).any?
            batch.each do |result|
              yield result
            end
          end
        end
      end

    end
  end
end