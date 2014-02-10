module CassandraObject
  module Adapters
    class AbstractAdapter
      attr_reader :config
      def initialize(config)
        @config = config
      end

      # Read records from a instance of CassandraObject::Scope
      def select(scope) # abstract
      end

      # Insert a new row
      def insert(table, id, attributes) # abstract
      end

      # Update an existing row
      def update(table, id, attributes) # abstract
      end

      # Delete rows by an array of ids
      def delete(table, ids) # abstract
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
