module Superstore
  module AttributeMethods
    module Dirty
      extend ActiveSupport::Concern
      include ActiveModel::Dirty

      # Attempts to +save+ the record and clears changed attributes if successful.
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
      def reload
        super.tap do
          clear_changes_information
        end
      end

      def unapplied_changes
        result = {}
        changed_attributes.each_key { |attr| result[attr] = read_attribute(attr) }
        result
      end
    end
  end
end
