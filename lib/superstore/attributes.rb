module Superstore
  module Attributes
    extend ActiveSupport::Concern

    module ClassMethods
      def attribute(name, options)
        type_name  = "superstore_#{options.fetch(:type)}".to_sym

        super(name, type_name)
      end
    end
  end
end
