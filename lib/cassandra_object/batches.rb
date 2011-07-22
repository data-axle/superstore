module CassandraObject
  module Batches
    extend ActiveSupport::Concern

    module ClassMethods
      def find_each
        connection.each(column_family) do |k, v|
          yield instantiate(k, v)
        end
      end
    end
  end
end