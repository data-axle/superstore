module Superstore
  module FinderMethods
    def find(ids)
      if ids.is_a?(Array)
        find_some(ids)
      else
        find_one(ids)
      end
    end

    def find_by_id(ids)
      find(ids)
    rescue Superstore::RecordNotFound
      nil
    end

    def all
      clone
    end

    def first
      limit(1).to_a.first
    end

    def to_ids
      klass.adapter.to_ids self
    end

    private

      def find_one(id)
        if id.blank?
          raise Superstore::RecordNotFound, "Couldn't find #{self.name} with key #{id.inspect}"
        elsif record = where_ids(id).first
          record
        else
          raise Superstore::RecordNotFound
        end
      end

      def find_some(ids)
        ids = ids.flatten
        return [] if ids.empty?

        ids = ids.compact.map(&:to_s).uniq

        where_ids(ids).to_a
      end
  end
end
