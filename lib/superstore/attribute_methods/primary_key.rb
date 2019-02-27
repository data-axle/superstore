# frozen_string_literal: true

module Superstore
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      included do
        attribute :id, type: :string
        include AttributeOverrides
      end

      module ClassMethods
        def primary_key
          'id'
        end
      end

      module AttributeOverrides
        def id
          value = super
          if value.nil?
            value = self.class._generate_key(self)
            @attributes.write_from_user(self.class.primary_key, value)
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
