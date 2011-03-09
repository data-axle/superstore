module CassandraObject
  module Timestamps
    extend ActiveSupport::Concern

    included do
      class_attribute :timestamp_override

      attribute :created_at, :type => :time_with_zone
      attribute :updated_at, :type => :time_with_zone

      before_create :set_created_at
      before_save :set_updated_at
    end

    def set_created_at
      self.created_at = Time.current unless self.class.timestamp_override
    end

    def set_updated_at
      self.updated_at = Time.current unless self.class.timestamp_override
    end
  end
end
