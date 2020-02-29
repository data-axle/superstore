# frozen_string_literal: true

module Superstore
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      included do
        include AttributeOverrides
      end

      module ClassMethods
        def has_id
          attribute :id, type: :string
        end

        def has_primary_key?
          attribute_names.include?(primary_key)
        end

        def attribute(name, options)
          super
          if name.to_sym == :id
            include AttributeOverrides
            extend PrimaryKeyOverrides
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
          if value.nil? && self.class.has_primary_key?
            value = self.class._generate_key(self)
            @attributes.write_from_user(self.class.primary_key, value)
          end
          value
        end

        def attributes
          if self.class.has_primary_key?
            super.update(self.class.primary_key => id)
          else
            super
          end
        end
      end
    end
  end
end
