module CassandraObject
  class Scope
    module QueryMethods
      def select!(value)
        self.select_values += Array.wrap(value)
        self
      end

      def select(value)
        clone.select! value
      end

      def where!(*values)
        self.where_values += values.flatten
        self
      end

      def where(*values)
        clone.where! values
      end

      def limit!(value)
        self.limit_value = value
        self
      end

      def limit(value)
        clone.limit! value
      end

      def to_a
        statement = [
          "select #{select_string} from #{klass.column_family}",
          where_string,
          limit_string
        ].delete_if(&:blank?) * ' '

        instantiate_from_cql(statement)
      end

      private
        def select_string
          if select_values.any?
            select_values * ','
          else
            '*'
          end
        end

        def where_string
          if where_values.any?
            wheres = []

            where_values.map do |where_value|
              if where_value.is_a?(String)
                wheres << where_value
              elsif where_value.is_a?(Hash)
                where_value.each do |column, value|
                  wheres << "#{column} = #{value}"
                end
              end
            end

            "WHERE #{wheres * ' AND '}"
          else
            ''
          end
        end

        def limit_string
          if limit_value
            "limit #{limit_value}"
          else
            ""
          end
        end
    end
  end
end