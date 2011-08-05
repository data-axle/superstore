module CassandraObject
  module Types
    class SetType
      def encode(set)
        if set.kind_of?(Set)
          set.to_json
        elsif set.kind_of?(Array)
          set.uniq.to_json
        else
          raise ArgumentError.new("#{self} requires an Array or Set")
        end
      end

      def decode(str)
        return str.to_a if str.kind_of?(Set)
        ActiveSupport::JSON.decode(str)
      end
    end
  end
end