module Superstore
  module Associations
    class Association
      attr_reader :owner, :reflection
      delegate :options, to: :reflection

      def initialize(owner, reflection)
        @owner = owner
        @reflection = reflection
        @loaded = false
      end

      def association_class
        association_class_name.constantize
      end

      def association_class_name
        reflection.polymorphic? ? owner.send(reflection.polymorphic_column) : reflection.class_name
      end

      def target=(target)
        @target = target
        loaded!
      end

      def target
        @target
      end

      def loaded?
        @loaded
      end

      def loaded!
        @loaded = true
      end
    end
  end
end
