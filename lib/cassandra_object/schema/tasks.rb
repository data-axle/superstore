module CassandraObject
  class Schema
    module Tasks
      def column_families
        # connection_config.servers, {keyspace: connection_config.keyspace}, connection_config.thrift_options

        families = `echo "DESCRIBE COLUMNFAMILIES;" | cqlsh -k #{CassandraObject::Base.connection_config.keyspace}`.split
        families.shift
        families.sort
      end
    end
  end
end