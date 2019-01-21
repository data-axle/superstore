module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern

    included do
      include ActiveModel::AttributeMethods
      extend ActiveRecord::AttributeMethods::ClassMethods
      include ActiveRecord::AttributeMethods::Read
      include ActiveRecord::AttributeMethods::Write
      extend ClassOverrides
      include InstanceOverrides

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
        attribute_definitions.key?(attr_name.to_s)
      end
    end

    module InstanceOverrides
      def write_attribute(name, value)
        @attributes[name.to_s] = self.class.typecast_attribute(name, value)
      end

      def read_attribute(name)
        name = name.to_s unless name.is_a?(String)

        if name == self.class.primary_key
          send(name)
        else
          @attributes[name]
        end
      end
      alias_method :_read_attribute, :read_attribute

      def attribute_present?(attribute)
        value = _read_attribute(attribute)
        !value.nil? && !(value.respond_to?(:empty?) && value.empty?)
      end

      def has_attribute?(name)
        @attributes.key?(name.to_s)
      end
      alias_method :attribute_exists?, :has_attribute?

      def attributes
        results = {}
        @attributes.each_key do |key|
          results[key] = read_attribute(key)
        end
        results
      end

      def attributes=(attributes)
        assign_attributes(attributes)
      end

      def method_missing(method_id, *args, &block)
        if (match = matched_attribute_method(method_id.to_s))
          attribute_missing(match, *args, &block)
        else
          super
        end
      end

      protected
        def attribute_method?(name)
          !!attribute_definitions[name.to_s]
        end

      private
        def attribute(name)
          read_attribute(name)
        end

        def attribute=(name, value)
          write_attribute(name, value)
        end
    end
  end
end
