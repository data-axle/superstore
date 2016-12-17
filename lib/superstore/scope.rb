require 'superstore/scope/batches'
require 'superstore/scope/finder_methods'
require 'superstore/scope/query_methods'

module Superstore
  class Scope
    include Batches, FinderMethods, QueryMethods

    attr_accessor :klass
    attr_accessor :limit_value, :select_values, :where_values, :id_values, :order_values

    def initialize(klass)
      @klass = klass

      @limit_value    = nil
      @select_values  = []
      @where_values   = []
      @order_values   = []
      @id_values      = []

      reset
    end

    def initialize_copy(other)
      @limit_value    = @limit_value.dup if @limit_value
      @select_values  = @select_values.dup
      @where_values   = @where_values.dup
      @order_values   = @order_values.dup
      @id_values      = @id_values.dup
      reset
    end

    def reset
      @records = nil
      @loaded = false
    end

    def ==(other)
      to_a == other
    end

    def to_ary
      to_a.to_ary
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

      def to_a
        unless @loaded
          @records = select_records
          @loaded  = true
        end
        @records
      end

      def select_records
        results = []
        klass.adapter.select(self) do |key, attributes|
          results << klass.instantiate(key, attributes)
        end
        results
      end
  end
end
