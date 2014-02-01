module CassandraObject
  module ConnectionAdapters
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

      def write(id, attributes) # abstract
      end

      def delete(ids) # abstract
      end

      def batch
        @batch_statements = []
        yield
        execute(@batch_statements) if @batch_statements.any?
      ensure
        @batch_statements = nil
      end

      def execute_batchable(statement, *bind_vars)
        if batch_statements
          batch_statements << CassandraCQL::Statement.sanitize(cql_string, bind_vars)
        else
          execute_cql cql_string, *bind_vars
        end
      end
    end
  end
end
