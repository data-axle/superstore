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
        if table_exists?
          @ignored_columns = [primary_key, superstore_column].freeze
          super
          @ignored_columns = [].freeze
        else
          @columns_hash = {}
        end

        attributes_to_define_after_schema_loads.each do |name, (cast_type, default)|
          define_attribute(name, cast_type, default: default)
        end
      end

      def attribute_names
        attribute_types.keys
      end

      def column_names
        attribute_names
      end
    end
  end
end
