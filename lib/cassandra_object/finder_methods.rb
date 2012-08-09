module CassandraObject
  module FinderMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def find(ids)
        if ids.is_a?(Array)
          find_some(ids)
        else
          find_one(ids)
        end
      end

      def find_by_id(ids)
        find(ids)
      rescue CassandraObject::RecordNotFound
        nil
      end

      def all
        instantiate_from_cql "select * from #{column_family}"
      end

      def first(options = {})
        instantiate_from_cql("select * from #{column_family} limit 1").first
      end

      private

      def instantiate_from_cql(cql_string, *args)
        results = []
        cql.execute(cql_string, *args).fetch do |cql_row|
          results << instantiate_cql_row(cql_row)
        end
        results.compact!
        results
      end

      def instantiate_cql_row(cql_row)
        attributes = cql_row.to_hash
        key = attributes.delete('KEY')
        if attributes.any?
          instantiate(key, attributes)
        end
      end
      
      def find_one(id)
        if id.blank?
          raise CassandraObject::RecordNotFound, "Couldn't find #{self.name} with key #{id.inspect}"
        elsif record = instantiate_from_cql("select * from #{column_family} where KEY = ? limit 1", id).first
          record
        else
          raise CassandraObject::RecordNotFound
        end
      end

      def find_some(ids)
        ids = ids.flatten
        return [] if ids.empty?

        ids = ids.compact.map(&:to_s).uniq

        statement = "select * from #{column_family} where KEY in (#{Array.new(ids.size, '?') * ','})"
        instantiate_from_cql statement, *ids
      end
    end
  end
end