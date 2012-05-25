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
        @id ||= self.class._generate_key(self)
      end

      def id=(id)
        @id = id
      end

      def attributes
        super.update(self.class.primary_key => id)
      end
    end
  end
end