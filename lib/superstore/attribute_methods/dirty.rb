module Superstore
  module AttributeMethods
    module Dirty
      extend ActiveSupport::Concern
      include ActiveModel::Dirty

      # Attempts to +save+ the record and clears changed attributes if successful.
      def save(*) #:nodoc:
        if status = super
          @previously_changed = changes
          @changed_attributes = {}
        end
        status
      end

      # <tt>reload</tt> the record and clears changed attributes.
      def reload
        super.tap do
          @previously_changed.try :clear
          @changed_attributes.try :clear
        end
      end

      def unapplied_changes
        result = {}
        changed_attributes.each_key { |attr| result[attr] = read_attribute(attr) }
        result
      end

      def old_attribute_value(attr)
        if attribute_changed?(attr)
          changed_attributes[attr]
        else
          read_attribute attr
        end
      end

      def write_attribute(name, value)
        name = name.to_s
        old = old_attribute_value(name)

        super

        if old == read_attribute(name)
          changed_attributes.delete(name)
        else
          changed_attributes[name] = old
        end
      end
    end
  end
end
