module Superstore
  module Associations
    extend ActiveSupport::Concern

    included do
      class_attribute :association_reflections
      self.association_reflections = {}
    end

    module ClassMethods
      # === Options
      # [:class_name]
      #   Use if the class cannot be inferred from the association
      # [:polymorphic]
      #   Specify if the association is polymorphic
      # Example:
      #   class Driver < Superstore::Base
      #   end
      #   class Truck < Superstore::Base
      #   end
      def belongs_to(name, options = {})
        Superstore::Associations::Builder::BelongsTo.build(self, name, options)
      end

      def has_many(name, options = {})
        Superstore::Associations::Builder::HasMany.build(self, name, options)
      end

      def has_one(name, options = {})
        Superstore::Associations::Builder::HasOne.build(self, name, options)
      end

      def generated_association_methods
        @generated_association_methods ||= begin
          mod = const_set(:GeneratedAssociationMethods, Module.new)
          include mod
          mod
        end
      end
    end

    # Returns the belongs_to instance for the given name, instantiating it if it doesn't already exist
    def association(name)
      instance = association_instance_get(name)

      if instance.nil?
        reflection = association_reflections[name]
        instance = reflection.association_class.new(self, reflection)
        association_instance_set(name, instance)
      end

      instance
    end

    private
      def clear_association_cache
        associations_cache.clear if persisted?
      end

      def associations_cache
        @associations_cache ||= {}
      end

      def association_instance_get(name)
        associations_cache[name.to_sym]
      end

      def association_instance_set(name, association)
        associations_cache[name.to_sym] = association
      end
  end
end
