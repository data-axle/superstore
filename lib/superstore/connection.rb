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

module Superstore
  module Connection
    extend ActiveSupport::Concern

    module ClassMethods
      def adapter
        @@adapter ||= adapter_class.new(config)
      end

      def adapter_class
        case config[:adapter]
        when 'hstore'
          Superstore::Adapters::HstoreAdapter
        when nil, 'cassandra'
          Superstore::Adapters::CassandraAdapter
        else
          raise "Unknown adapter #{config[:adapter]}"
        end
      end
    end
  end
end
