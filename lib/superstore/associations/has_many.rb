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

        self.target = load_collection
      end

      private

        def load_collection
          association_class.where(reflection.foreign_key => owner.try(reflection.primary_key))
        end

    end
  end
end