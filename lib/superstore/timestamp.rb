module Superstore
  module Timestamp
    extend ActiveSupport::Concern

    class_methods do
      def inherited(child)
        super
        child.attribute :created_at, type: :time
        child.attribute :updated_at, type: :time
      end
    end
  end
end
