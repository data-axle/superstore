module CassandraObject
  module Connection
    extend ActiveSupport::Concern
    
    included do
      class_attribute :connection
    end

    module ClassMethods
      def establish_connection(spec)
        self.connection = Cassandra.new(spec[:keyspace], spec[:servers])
      end
    end
  end
end
