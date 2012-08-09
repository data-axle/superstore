CassandraObject::Base.establish_connection(
  keyspace: 'system',
  servers: '127.0.0.1:9160'
)

begin
  CassandraObject::Schema.drop_keyspace 'cassandra_object_test'
rescue
end

CassandraObject::Schema.create_keyspace 'cassandra_object_test'

CassandraObject::Base.establish_connection(
  keyspace: 'cassandra_object_test',
  servers: '127.0.0.1:9160'
)

CassandraObject::Schema.create_column_family 'Issues'
