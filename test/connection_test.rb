require 'test_helper'

class CassandraObject::ConnectionTest < CassandraObject::TestCase
  class TestObject < CassandraObject::Base
  end

  test 'establish_connection' do
    TestObject.establish_connection(
      keyspace: 'place_directory_development',
      servers: '192.168.0.100:9160'
    )

    assert_not_equal CassandraObject::Base.connection, TestObject.connection
    assert_equal 'place_directory_development', TestObject.connection.keyspace
    assert_equal ["192.168.0.100:9160"], TestObject.connection.servers
  end
end