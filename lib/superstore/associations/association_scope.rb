module Superstore
  module Associations
    class AssociationScope < ActiveRecord::Relation
      def initialize(klass, association)
        super(klass, klass.arel_table, klass.predicate_builder)
        @association = association
      end

      def exec_queries
        super.each { |r| @association.set_inverse_instance r }
      end
    end
  end
end