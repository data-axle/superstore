module Superstore
  module Types
    class ArrayType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def encode(array)
        if model.config[:adapter] == 'jsonb'
          array
        else
          Oj.dump(array, OJ_OPTIONS)
        end
      end

      def decode(val)
        return nil if val.blank?

        if model.config[:adapter] == 'jsonb'
          val
        else
          Oj.compat_load(val)
        end
      end

      def typecast(value)
        value.to_a
      end
    end
  end
end
