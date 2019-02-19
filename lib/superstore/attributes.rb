module Superstore
  module Attributes
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Attributes
      extend ClassOverrides
      class_attribute :attribute_set_class
      self.attribute_set_class = Rails.version >= '5.2' ? ActiveModel::AttributeSet : ActiveRecord::AttributeSet

      %w(array boolean date date_range float integer integer_range json string time).each do |type|
        instance_eval <<-EOV, __FILE__, __LINE__ + 1
          def #{type}(*args)
            options = args.extract_options!
            args.each do |name|
              attribute(name, options.merge(:type => :#{type}))
            end
          end
        EOV
      end
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
