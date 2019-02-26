module Superstore
  module ModelSchema
    extend ActiveSupport::Concern

    module ClassMethods
      def attributes_builder # :nodoc:
        @attributes_builder ||= ActiveModel::AttributeSet::Builder.new(attribute_types, _default_attributes)
      end

      def table_exists?
        true
      end

      def load_schema!
        @columns_hash = {}
      end

      def column_names
        attribute_names
      end
    end
  end
end
