module CassandraObject
  module Adapters
    class AbstractAdapter
      attr_reader :config
      def initialize(config)
        @config = config
      end

      # === Options
      # [:select]
      #   Only select certain fields
      # [:limit]
      #   Limit the results
      def select(ids, options ={}) # abstract
      end

      def insert(table, id, attributes) # abstract
      end

      def update(table, id, attributes) # abstract
      end

      def delete(ids) # abstract
      end

      def execute_batch(statements) # abstract
      end

      def batching?
        !@batch_statements.nil?
      end

      def batch
        @batch_statements = []
        yield
        execute_batch(@batch_statements) if @batch_statements.any?
      ensure
        @batch_statements = nil
      end

      def execute_batchable(statement)
        if @batch_statements
          @batch_statements << statement
        else
          execute statement
        end
      end
    end
  end
end
