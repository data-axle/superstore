module Superstore
  module AttributeAssignment
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::AttributeAssignment
      include InstanceOverrides
    end

    module InstanceOverrides
      def _assign_attribute(k, v)
        public_send("#{k}=", v) if respond_to?("#{k}=")
      end
    end
  end
end
