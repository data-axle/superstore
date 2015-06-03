module Superstore
  module Types
    class JsonType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def encode(data)
        if model.adapter.is_a?(Superstore::Adapters::CassandraAdapter)
          Oj.dump(data, OJ_OPTIONS)
        else
          data
        end
      end

      def decode(str)
        if model.adapter.is_a?(Superstore::Adapters::CassandraAdapter)
          Oj.compat_load(str)
        else
          str
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
