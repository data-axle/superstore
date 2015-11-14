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
        reader.instance_variable_set :@records, records
        reader.instance_variable_set :@loaded, true
        loaded!
      end

      private

        def load_collection
          association_class.where(reflection.foreign_key => owner.try(reflection.primary_key))
        end

    end
  end
end