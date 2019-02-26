# frozen_string_literal: true

module Superstore
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      included do
        p "****************"
        p "WE WERE INCLUDED!!!!!!"
        p "****************"
        attribute :id, type: :string
      end

      module ClassMethods
        def primary_key
          'id'
        end
      end

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
