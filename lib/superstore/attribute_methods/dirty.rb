module Superstore
  module AttributeMethods
    module Dirty
      extend ActiveSupport::Concern
      include ActiveModel::Dirty

      included do
        class_attribute :partial_writes, instance_writer: false
        self.partial_writes = true
      end

      def save(*) #:nodoc:
        if status = super
          changes_applied
        end
        status
      end

      def save!(*)
        super.tap do
          changes_applied
        end
      end

      # <tt>reload</tt> the record and clears changed attributes.
      def reload(*)
        super.tap do
          clear_changes_information
        end
      end

      def _update_record(*)
        super(changed_attributes.keys)
      end

      def _create_record(*)
        super(changed_attributes.keys)
      end

      def has_changes_to_save?
        changed_attributes.any?
      end

      def will_save_change_to_attribute?(attr)
        attribute_changed?(attr)
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
