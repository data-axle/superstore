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
      def adapter
        @@adapter ||= CassandraObject::Adapters::CassandraAdapter.new(config)
        # @@adapter ||= CassandraObject::Adapters::HstoreAdapter.new(config)
      end
    end
  end
end
