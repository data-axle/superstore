require 'cassandra_object/scope/batches'
require 'cassandra_object/scope/finder_methods'
require 'cassandra_object/scope/query_methods'

module CassandraObject
  class Scope
    include Batches, FinderMethods, QueryMethods

    attr_accessor :klass
    attr_accessor :limit_value, :select_values, :where_values

    def initialize(klass)
      @klass = klass

      @limit_value = nil
      @select_values = []
      @where_values = []
    end

    private

      def scoping
        previous, klass.current_scope = klass.current_scope, self
        yield
      ensure
        klass.current_scope = previous
      end

      def method_missing(method_name, *args, &block)
        if klass.respond_to?(method_name)
          scoping { klass.send(method_name, *args, &block) }
        elsif Array.method_defined?(method_name)
          to_a.send(method_name, *args, &block)
        else
          super
        end
      end

      def instantiate_from_cql(cql_string)
        results = []
        klass.adapter.execute(cql_string).fetch do |cql_row|
          results << instantiate_cql_row(cql_row)
        end
        results.compact!
        results
      end

      def instantiate_cql_row(cql_row)
        attributes = cql_row.to_hash
        key = attributes.delete('KEY')
        if attributes.any?
          klass.instantiate(key, attributes)
        end
      end
  end
end
