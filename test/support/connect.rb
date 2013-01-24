CassandraObject::Base.config = {
  keyspace: 'cassandra_object_test',
  servers: '127.0.0.1:9160',
  thrift: {
    timeout: 5
  }
}

begin
  CassandraObject::Schema.drop_keyspace 'cassandra_object_test'
rescue Exception => e
end

sleep 1
CassandraObject::Schema.create_keyspace 'cassandra_object_test'
CassandraObject::Schema.create_column_family 'Issues'
CassandraObject::Base.default_consistency = 'QUORUM'
