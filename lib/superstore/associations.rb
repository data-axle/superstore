module Superstore
  module Associations
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Associations
      extend ClassOverrides
    end

    module ClassOverrides
      # === Options
      # [:class_name]
      #   Use if the class cannot be inferred from the association
      # [:polymorphic]
      #   Specify if the association is polymorphic
      # Example:
      #   class Driver < Superstore::Base
      #   end
      #   class Truck < Superstore::Base
      #   end
      def belongs_to(name, **options)
        if options.delete(:superstore)
          Superstore::Associations::Builder::BelongsTo.build(self, name, options)
        else
          super
        end
      end

      def has_many(name, **options)
        if options.delete(:superstore)
          Superstore::Associations::Builder::HasMany.build(self, name, options)
        else
          super
        end
      end

      def has_one(name, **options)
        if options.delete(:superstore)
          Superstore::Associations::Builder::HasOne.build(self, name, options)
        else
          super
        end
      end

      def belongs_to_required_by_default
        false
      end
    end

  end
end
