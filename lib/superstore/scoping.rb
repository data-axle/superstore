module Superstore
  module Scoping
    extend ActiveSupport::Concern

    included do
      singleton_class.class_eval do
        delegate :find, :find_by_id, :first, :all, :pluck, to: :scope
        delegate :find_each, :find_in_batches, to: :scope
        delegate :select, :where, :where_ids, to: :scope
      end

      class_attribute :default_scopes, instance_writer: false, instance_predicate: false
      self.default_scopes = []
    end

    module ClassMethods
      def scope
        self.current_scope ||= Scope.new(self)
      end

      def current_scope
        Thread.current["#{self}_current_scope"]
      end

      def current_scope=(new_scope)
        Thread.current["#{self}_current_scope"] = new_scope
      end
    end
  end
end
