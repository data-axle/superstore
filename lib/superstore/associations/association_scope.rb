module Superstore
  module Associations
    class AssociationScope < ActiveRecord::Relation
      def initialize(klass, association)
        super(klass)
        @association = association
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
