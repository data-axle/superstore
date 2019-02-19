module Superstore
  module Associations
    class AssociationScope < ActiveRecord::Relation
      if Rails.version >= '5.2'
        def initialize(klass, association)
          super(klass)
          @association = association
        end
      else
        def initialize(klass, association)
          super(klass, klass.arel_table, klass.predicate_builder)
          @association = association
        end
      end

      def exec_queries
        super.each { |r| @association.set_inverse_instance r }
      end

      def <<(*records)
        if loaded?
          @records = @records + records
        end
      end
    end
  end
end
