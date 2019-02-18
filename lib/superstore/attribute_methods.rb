module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::AttributeMethods

      extend ClassOverrides
      include PrimaryKey
    end

    module ClassOverrides
      def dangerous_class_method?(method_name)
        false
      end

      def dangerous_attribute_method?(name) # :nodoc:
        false
      end
    end
  end
end
