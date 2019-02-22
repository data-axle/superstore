module Superstore
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      included do
        attribute :id, type: :string

        extend ClassOverrides
        include InstanceOverrides
      end

      module ClassOverrides
        def primary_key
          'id'.freeze
        end
      end

      module InstanceOverrides
        def id
          value = super
          if value.nil?
            value = self.class._generate_key(self)
            self.id = value
          end
          value
        end

        def attributes
          super.update(self.class.primary_key => id)
        end
      end
    end
  end
end
