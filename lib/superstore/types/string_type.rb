module Superstore
  module Types
    class StringType < BaseType
      def encode(str)
        raise ArgumentError.new("#{str.inspect} is not a String") unless str.kind_of?(String)

        unless str.encoding == Encoding::UTF_8
          (str.frozen? ? str.dup : str).force_encoding('UTF-8')
        else
          str
        end
      end

      def typecast(name, value, current_value = nil)
        current_value ||= ActiveModel::Attribute.from_user(name, nil, ActiveModel::Type::String.new)

        ActiveModel::Attribute.from_user(name, value.to_s, ActiveModel::Type::String.new, current_value)
      end
    end
  end
end
