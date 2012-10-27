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
  class Config
    attr_accessor :servers, :keyspace, :thrift_options

    def initialize(options)
      self.servers  = Array.wrap(options[:servers] || "127.0.0.1:9160")
      self.keyspace = options[:keyspace]
      self.thrift_options = (options[:thrift] || {}).symbolize_keys
    end
  end

  module Connection
    extend ActiveSupport::Concern

    included do
      class_attribute :connection_config
    end

    module ClassMethods
      def establish_connection(spec)
        self.connection_config = Config.new(spec)
      end

      def cql
        @@cql ||= CassandraCQL::Database.new(connection_config.servers, {keyspace: connection_config.keyspace}, connection_config.thrift_options)
      end

      def execute_cql(cql_string, *bind_vars)
        statement = CassandraCQL::Statement.sanitize(cql_string, bind_vars)
        ActiveSupport::Notifications.instrument("cql.cassandra_object", cql: statement) do
          cql.execute statement
        end
      end
    end
  end
end
