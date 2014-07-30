module Superstore
  module Timestamps
    extend ActiveSupport::Concern

    included do
      attribute :created_at, type: :time
      attribute :updated_at, type: :time

      before_create do
        self.created_at ||= Time.current
        self.updated_at ||= Time.current
      end

      before_update if: :changed? do
        self.updated_at = Time.current unless self.changed_attributes.key?("updated_at")
      end
    end
  end
end
