module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern

    included do
      include ActiveModel::AttributeMethods
      extend ActiveRecord::AttributeMethods::ClassMethods

      extend ClassOverrides
      include InstanceOverrides

      include ActiveRecord::AttributeMethods::Read
      include ActiveRecord::AttributeMethods::Write
      include ActiveRecord::AttributeMethods::BeforeTypeCast
      include PrimaryKey
      include Dirty

      # (Alias for the protected read_attribute method).
      def [](attr_name)
        read_attribute(attr_name)
      end

      # Updates the attribute identified by <tt>attr_name</tt> with the specified +value+.
      # (Alias for the protected write_attribute method).
      def []=(attr_name, value)
        write_attribute(attr_name, value)
      end
    end

    module ClassOverrides
      def dangerous_class_method?(method_name)
        false
      end

      def dangerous_attribute_method?(name) # :nodoc:
        # method_defined_within?(name, Base)
        false
      end

      def has_attribute?(attr_name)
        attribute_types.key?(attr_name.to_s)
      end

      def column_names
        attribute_names
      end
    end

    module InstanceOverrides
      def attribute_present?(attribute)
        value = _read_attribute(attribute)
        !value.nil? && !(value.respond_to?(:empty?) && value.empty?)
      end

      def has_attribute?(name)
        @attributes.key?(name.to_s)
      end

      def attribute_names
        @attributes.keys
      end

      def attributes
        @attributes.to_hash
      end

      def attribute_for_inspect(value)
        if value.is_a?(String) && value.length > 50
          "#{value[0..50]}...".inspect
        elsif value.is_a?(Date) || value.is_a?(Time)
          %("#{value.to_s(:db)}")
        else
          value.inspect
        end
      end

      protected

        def attribute_method?(attr_name) # :nodoc:
          # We check defined? because Syck calls respond_to? before actually calling initialize.
          defined?(@attributes) && @attributes.key?(attr_name)
        end
    end
  end
end
