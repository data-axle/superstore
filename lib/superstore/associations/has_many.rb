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

        # TODO: Use relation.load_records with Rails 5
        relation.instance_variable_set :@records, records
        relation.instance_variable_set :@loaded, true

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
          AssociationScope.new(association_class, self).where("#{owner.superstore_column} ->> '#{reflection.foreign_key}' = '#{owner.try(reflection.primary_key)}'")
        end
    end
  end
end
