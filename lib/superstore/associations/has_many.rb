module Superstore
  module Associations
    class HasMany < Association
      def reader
        unless loaded?
          self.target = load_collection
        end

        target
      end

      def writer(records)
        relation = load_collection
        relation.load_records(records)

        self.target = relation
      end

      def set_inverse_instance(record)
        return unless reflection.inverse_name

        inverse = record.association(reflection.inverse_name)
        inverse.target = owner
      end

      private

        def inverse_of
          return unless reflection.inverse_name

          @inverse_of ||= association_class.reflect_on_association reflection.inverse_name
        end

        def load_collection
          AssociationScope.new(association_class, self).where("document ->> '#{reflection.foreign_key}' = '#{owner.try(reflection.primary_key)}'")
        end

    end
  end
end
