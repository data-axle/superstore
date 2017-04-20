module Superstore
  module AttributeMethods
    module PrimaryKey
      extend ActiveSupport::Concern

      module ClassMethods
        PRIMARY_KEY = 'id'
        def primary_key
          PRIMARY_KEY
        end
      end

      def id
        @id ||= self.class._generate_key(self)
      end

      def id=(id)
        @id = id
      end

      def attributes
        super.update(self.class.primary_key => id)
      end

      def quoted_primary_key
        @quoted_primary_key ||= connection.quote_column_name(primary_key)
      end
    end
  end
end
