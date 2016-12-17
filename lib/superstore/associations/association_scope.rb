module Superstore
  module Associations
    class AssociationScope < Scope
      def initialize(klass, association)
        super(klass)
        @association = association
      end

      def to_a
        super.each { |r| @association.set_inverse_instance r }
      end
    end
  end
end