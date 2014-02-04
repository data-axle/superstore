module CassandraObject
  module Consistency
    extend ActiveSupport::Concern

    module ClassMethods
      def with_consistency(consistency)
        previous, self.default_consistency = default_consistency, consistency
        yield
      ensure
        self.default_consistency = previous
      end

      def default_consistency=(value)
        adapter.consistency = value
      end

      def default_consistency
        adapter.consistency
      end
    end
  end
end
