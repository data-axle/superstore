module Superstore
  module Attributes
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Attributes
      extend ClassOverrides
    end

    module ClassOverrides
      #
      # attribute :name, type: :string
      # attribute :ammo, type: :integer
      #
      def attribute(name, options)
        type_name  = "superstore_#{options.fetch(:type)}".to_sym

        super(name, type_name)
      end
    end
  end
end
