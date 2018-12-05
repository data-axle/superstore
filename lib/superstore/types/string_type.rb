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

      def typecast(name, value)
        ActiveModel::Attribute.from_user(name, value.to_s, ActiveModel::Type::String.new)
      end
    end
  end
end
