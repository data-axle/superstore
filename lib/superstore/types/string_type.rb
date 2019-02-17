module Superstore
  module Types
    class StringType < ActiveModel::Type::Value
      def serialize(str)
        raise ArgumentError.new("#{str.inspect} is not a String") unless str.kind_of?(String)

        unless str.encoding == Encoding::UTF_8
          (str.frozen? ? str.dup : str).force_encoding('UTF-8')
        else
          str
        end
      end

      def cast_value(value)
        value.to_s
      end
    end
  end
end
