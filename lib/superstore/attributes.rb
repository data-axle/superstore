module Superstore
  module Attributes
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Attributes
      extend ClassOverrides

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

      def attributes_builder # :nodoc:
        @attributes_builder ||= ActiveRecord::AttributeSet::Builder.new(attribute_types, _default_attributes)
      end
    end
  end
end
