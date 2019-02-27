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

      def column_names
        attribute_names
      end
    end
  end
end
