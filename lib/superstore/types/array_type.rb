module Superstore
  module Types
    class ArrayType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def encode(array)
        if Superstore::Base.adapter.is_a?(Superstore::Adapters::JsonbAdapter)
          array
        else
          Oj.dump(data, OJ_OPTIONS)
        end
      end

      def decode(str)
        return nil if str.blank?

        if Superstore::Base.adapter.is_a?(Superstore::Adapters::JsonbAdapter)
          str
        else
          Oj.compat_load(str)
        end
      end

      def typecast(value)
        value.to_a
      end
    end
  end
end
