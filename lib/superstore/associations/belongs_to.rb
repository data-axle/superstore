module Superstore
  module Associations
    class BelongsTo < Association
      def reader
        unless loaded?
          self.target = get_record
        end

        target
      end

      def writer(record)
        self.target = record
        owner.send("#{reflection.foreign_key}=", record.try(reflection.primary_key))
        if reflection.polymorphic?
          owner.send("#{reflection.polymorphic_column}=", record.class.name)
        end
      end

      def belongs_to?; true; end

      private

        def get_record
          record_id = owner.send(reflection.foreign_key).presence
          return unless record_id

          if reflection.default_primary_key?
            association_class.find_by_id(record_id)
          else
            association_class.find_by(reflection.primary_key => record_id)
          end
        end

    end
  end
end
