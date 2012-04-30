module CassandraObject
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      module ClassMethods
        def primary_key
          'id'
        end
      end

      def id
        key.to_s
      end

      def id=(key)
        @key = self.class.parse_key(key)
        id
      end

      def attributes
        super.update(self.class.primary_key => id)
      end
    end
  end
end