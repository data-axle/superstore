# frozen_string_literal: true

module Superstore
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      module ClassMethods
        def has_id
          attribute :id, type: :string
        end

        def attribute(name, options)
          super
          if name == :id
            extend PrimaryKeyOverrides
            include AttributeOverrides
          end
        end
      end

      module PrimaryKeyOverrides
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
