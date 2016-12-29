module Superstore
  module Core
    extend ActiveSupport::Concern

    module ClassMethods
      def inspect
        if self == Base
          super
        else
          attr_list = attribute_definitions.keys * ', '
          "#{super}(#{attr_list.truncate(140 * 1.7337)})"
        end
      end

      def initialize_generated_modules # :nodoc:
        generated_association_methods
      end

      def generated_association_methods
        @generated_association_methods ||= begin
          mod = const_set(:GeneratedAssociationMethods, Module.new)
          include mod
          mod
        end
      end

      def arel_table # :nodoc:
        @arel_table ||= Arel::Table.new(table_name, self)
      end

      def subclass_from_attributes?(attrs)
        false
      end
    end

    def initialize(attributes=nil)
      @new_record         = true
      @destroyed          = false
      @association_cache  = {}

      @attributes         = {}
      self.attributes = attributes || {}

      yield self if block_given?
    end

    def initialize_dup(other)
      @attributes = @attributes.deep_dup
      @attributes['created_at'] = nil
      @attributes['updated_at'] = nil
      @attributes.delete(self.class.primary_key)
      @id = nil
      @new_record = true
      @destroyed = false
      @association_cache = {}
      super
    end

    def to_param
      id
    end

    def hash
      id.hash
    end

    def ==(comparison_object)
      comparison_object.equal?(self) ||
        (comparison_object.instance_of?(self.class) &&
          comparison_object.id == id)
    end

    def eql?(comparison_object)
      self == (comparison_object)
    end
  end
end
