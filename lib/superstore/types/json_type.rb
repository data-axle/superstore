module Superstore
  module Types
    class JsonType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def encode(data)
        if Superstore::Base.adapter.is_a?(Superstore::Adapters::JsonbAdapter)
          data
        else
          Oj.dump(data, OJ_OPTIONS)
        end
      end

      def decode(str)
        if Superstore::Base.adapter.is_a?(Superstore::Adapters::JsonbAdapter)
          str
        else
          Oj.compat_load(str)
        end
      end

      def typecast(data)
        if data.acts_like?(:time) || data.acts_like?(:date)
          data.as_json
        elsif data.is_a?(Array)
          data.map { |d| typecast(d) }
        elsif data.is_a?(Hash)
          data.each_with_object({}) { |(key, value), hash| hash[key] = typecast(value) }
        else
          data
        end
      end
    end
  end
end
