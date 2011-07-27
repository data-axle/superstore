require 'test_helper'

class CassandraObject::ConnectionTest < CassandraObject::TestCase
  class TestObject < CassandraObject::Base
  end

  test 'establish_connection' do
    TestObject.establish_connection(
      keyspace: 'place_directory_development',
      servers: '192.168.0.100:9160',
      thrift: {'timeout' => 10}
    )

    assert_not_equal CassandraObject::Base.connection, TestObject.connection
    assert_equal 'place_directory_development', TestObject.connection.keyspace
    assert_equal ["192.168.0.100:9160"], TestObject.connection.servers
    assert_equal 10, TestObject.connection.thrift_client_options['timeout']
  end

  test 'establish_connection defaults' do
    TestObject.establish_connection(
      keyspace: 'place_directory_development'
    )

    assert_equal 'place_directory_development', TestObject.connection.keyspace
    assert_equal ["127.0.0.1:9160"], TestObject.connection.servers
  end
end