module CassandraObject
  class Scope
    module QueryMethods
      def select(value)
        clone.select_values += Array.wrap(value)
      end

      def where(values)
        clone.where_values += values.flatten
      end

      def limit(value)
        clone.limit_value = value
      end
    end
  end
end