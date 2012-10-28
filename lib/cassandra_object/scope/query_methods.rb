module CassandraObject
  class Scope
    module QueryMethods
      def select!(*values)
        self.select_values += values.flatten
        self
      end

      def select(*values, &block)
        if block_given?
          to_a.select(&block)
        else
          clone.select! *values
        end
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
          "SELECT #{select_string} FROM #{klass.column_family}",
          consistency_string,
          where_string,
          limit_string
        ].delete_if(&:blank?) * ' '

        instantiate_from_cql(statement)
      end

      private
        def select_string
          if select_values.any?
            (['KEY'] | select_values) * ','
          else
            '*'
          end
        end

        def where_string
          if where_values.any?
            wheres = []

            where_values.map do |where_value|
              wheres.concat format_where_statement(where_value)
            end

            "WHERE #{wheres * ' AND '}"
          else
            ''
          end
        end

        def format_where_statement(where_value)
          if where_value.is_a?(String)
            [where_value]
          elsif where_value.is_a?(Hash)
            where_value.map do |column, value|
              if value.is_a?(Array)
                "#{column} IN (#{escape_where_value(value)})"
              else
                "#{column} = #{escape_where_value(value)}"
              end
            end
          end
        end

        def escape_where_value(value)
          if value.is_a?(Array)
            value.map { |v| escape_where_value(v) }.join(",")
          elsif value.is_a?(String)
            value = value.gsub("'", "''")
            "'#{value}'"
          else
            value
          end
        end

        def limit_string
          if limit_value
            "LIMIT #{limit_value}"
          else
            ""
          end
        end

        def consistency_string
          if klass.default_consistency
            "USING CONSISTENCY #{klass.default_consistency}"
          end
        end
    end
  end
end
