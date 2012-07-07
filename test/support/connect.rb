CassandraObject::Base.establish_connection(
  keyspace: 'cassandra_object_test',
  servers: '127.0.0.1:9160'
)

CassandraObject::Tasks::Keyspace.new.tap do |keyspace_task|
  keyspace_task.create('cassandra_object_test') unless keyspace_task.exists?('cassandra_object_test')
end

CassandraObject::Tasks::ColumnFamily.new('cassandra_object_test').tap do |column_family_task|
  column_family_task.create('Issues') unless column_family_task.exists?('Issues')
end