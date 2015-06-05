module Superstore
  module Types
    class ArrayType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def encode(array)
        if model.adapter.class.name == 'Superstore::Adapters::CassandraAdapter'
          Oj.dump(array, OJ_OPTIONS)
        else
          array
        end
      end

      def decode(val)
        return nil if val.blank?

        if model.adapter.class.name == 'Superstore::Adapters::CassandraAdapter'
          Oj.compat_load(val)
        else
          val
        end
      end

      def typecast(value)
        value.to_a
      end
    end
  end
end
