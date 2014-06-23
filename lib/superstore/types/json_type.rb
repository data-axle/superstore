module Superstore
  module Types
    class JsonType < BaseType
      def encode(data)
        ActiveSupport::JSON.encode(data)
      end

      def decode(str)
        ActiveSupport::JSON.decode(str)
      end

      def typecast(data)
        return data if ActiveSupport.parse_json_times

        if data.acts_like?(:time)
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
