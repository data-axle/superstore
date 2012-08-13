module CassandraObject
  module Scoping
    extend ActiveSupport::Concern

    included do
      singleton_class.class_eval do
        delegate :find, :find_by_id, :first, :all, to: :scope
        delegate :find_each, :find_in_batches, to: :scope
        delegate :select, :where, to: :scope
      end
    end
  end
end
