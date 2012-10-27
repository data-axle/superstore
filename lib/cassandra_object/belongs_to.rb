module CassandraObject
  module BelongsTo
    extend ActiveSupport::Concern

    included do
      class_attribute :belongs_to_reflections
      self.belongs_to_reflections = {}
    end

    module ClassMethods
      # === Options
      # [:class_name]
      #   Use if the class cannot be inferred from the association
      # [:polymorphic]
      #   Specify if the association is polymorphic
      # Example:
      #   class Driver < CassandraObject::Base
      #   end
      #   class Truck < CassandraObject::Base
      #   end
      def belongs_to(name, options = {})
        CassandraObject::BelongsTo::Builder.build(self, name, options)
      end

      def generated_belongs_to_methods
        @generated_belongs_to_methods ||= begin
          mod = const_set(:GeneratedBelongsToMethods, Module.new)
          include mod
          mod
        end
      end
    end

    # Returns the belongs_to instance for the given name, instantiating it if it doesn't already exist
    def belongs_to_association(name)
      association = belongs_to_instance_get(name)

      if association.nil?
        association = CassandraObject::BelongsTo::Association.new(self, belongs_to_reflections[name])
        belongs_to_instance_set(name, association)
      end

      association
    end

    private
      def belongs_to_cache
        @belongs_to_cache ||= {}
      end

      def belongs_to_instance_get(name)
        belongs_to_cache[name.to_sym]
      end

      def belongs_to_instance_set(name, association)
        belongs_to_cache[name.to_sym] = association
      end
  end
end
