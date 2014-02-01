module CassandraObject
  module ConnectionAdapters
    class CassandraAdapter < AbstractAdapter
      # def escape_where_value(value)
      #   if value.is_a?(Array)
      #     value.map { |v| escape_where_value(v) }.join(",")
      #   elsif value.is_a?(String)
      #     value = value.gsub("'", "''")
      #     "'#{value}'"
      #   else
      #     value
      #   end
      # end
      def select(ids, options ={})
        select_string = options[:select] ? (['KEY'] | select_values) * ',' : '*'
        where_string  = sanitize(ids.is_a?(Array) ? "KEY IN (?)" : "KEY = ?", ids)
        limit_string  = options[:limit] ? sanitize("LIMIT ?", limit[:limit]) : nil

        [
          "SELECT #{select_string} FROM #{klass.column_family}",
          consistency_string,
          where_string,
          limit_string
        ].delete_if(&:blank?) * ' '
      end

      def write(id, attributes)
        if (encoded = encode_attributes(attributes)).any?
          insert_attributes = {'KEY' => id}.update encode_attributes(attributes)
          statement = "INSERT INTO #{column_family} (#{quote_columns(insert_attributes.keys) * ','}) VALUES (#{Array.new(insert_attributes.size, '?') * ','})#{write_option_string}"
          execute_batchable sanitize(statement, insert_attributes.values)
        end

        if (nil_attributes = attributes.select { |key, value| value.nil? }).any?
          execute_batchable sanitize("DELETE #{quote_columns(nil_attributes.keys) * ','} FROM #{column_family}#{write_option_string} WHERE KEY = ?", id)
        end
      end

      def delete(ids)
        statement = "DELETE FROM #{column_family}#{write_option_string} WHERE "
        statement += ids.is_a?(Array) ? "KEY IN (?)" : "KEY = ?"

        execute_batchable sanitize(statement, ids)
      end

      private

        def sanitize(statement, *bind_vars)
          CassandraCQL::Statement.sanitize(statement, bind_vars)
        end

        def quote_columns(column_names)
          column_names.map { |name| "'#{name}'" }
        end

        def consistency

        end

        def write_option_string
          if !batching? && base_class.default_consistency
            " USING CONSISTENCY #{consistency}"
          end
        end
    end
  end
end
