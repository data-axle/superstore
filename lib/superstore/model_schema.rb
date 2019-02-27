module Superstore
  module ModelSchema
    extend ActiveSupport::Concern

    included do
      class_attribute :superstore_column, default: 'document'
    end

    module ClassMethods
      def attributes_builder # :nodoc:
        @attributes_builder ||= ActiveModel::AttributeSet::Builder.new(attribute_types, _default_attributes)
      end

      def load_schema! # :nodoc:
        @columns_hash = {}

        attributes_to_define_after_schema_loads.each do |name, (type, options)|
          if type.is_a?(Symbol)
            type = ActiveRecord::Type.lookup(type, **options.except(:default))
          end

          define_attribute(name, type, **options.slice(:default))
        end
      end

      def column_names
        attribute_names
      end
    end
  end
end
