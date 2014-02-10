module CassandraCQL
  class Statement
    def self.sanitize(statement, bind_vars=[])
      return statement if bind_vars.empty?

      bind_vars = bind_vars.dup
      expected_bind_vars = statement.count("?")

      raise Error::InvalidBindVariable, "Wrong number of bound variables (statement expected #{expected_bind_vars}, was #{bind_vars.size})" if expected_bind_vars != bind_vars.size

      statement.gsub(/\?/) do
        quote(cast_to_cql(bind_vars.shift))
      end
    end
  end
end

module CassandraObject
  module Connection
    extend ActiveSupport::Concern

    module ClassMethods
      def cql
        @@cql ||= CassandraCQL::Database.new(config.servers, {keyspace: config.keyspace}, config.thrift_options)
      end

      def adapter
        # @@adapter ||= CassandraObject::Adapters::CassandraAdapter.new(config)
        @@adapter ||= CassandraObject::Adapters::HstoreAdapter.new(config)
      end

      def execute_cql(cql_string, *bind_vars)
        statement = CassandraCQL::Statement.sanitize(cql_string, bind_vars).force_encoding(Encoding::UTF_8)

        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          cql.execute statement
        end
      end
    end
  end
end
