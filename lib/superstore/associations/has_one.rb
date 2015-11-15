module Superstore
  module Associations
    class HasOne < Association
      def reader
        unless loaded?
          self.target = load_target
        end

        target
      end

      def writer(record)
        self.target = record
      end

      private

        def load_target
          association_class.where(reflection.foreign_key => owner.try(reflection.primary_key)).first
        end

    end
  end
end