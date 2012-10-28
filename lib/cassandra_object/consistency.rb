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
    end

    included do
      class_attribute :default_consistency
    end
  end
end
