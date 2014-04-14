module Superstore
  class Schema
    class << self
      def create_table(table_name, options = {})
        adapter.create_table table_name, options
      end

      def drop_table(table_name)
        adapter.drop_table table_name
      end

      private

        def adapter
          Superstore::Base.adapter
        end

    end
  end
end
