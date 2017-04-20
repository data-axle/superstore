module Superstore
  module Adapters
    class AbstractAdapter
      def initialize
      end

      # Read records from a instance of Superstore::Scope
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
    end
  end
end
