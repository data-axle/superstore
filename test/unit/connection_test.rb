require 'test_helper'

class CassandraObject::ConnectionTest < CassandraObject::TestCase
  class TestObject < CassandraObject::Base
  end

  test "sanitize supports question marks" do
    assert_equal 'hello ?', CassandraCQL::Statement.sanitize('hello ?')
  end

  test 'establish_connection' do
    TestObject.establish_connection(
      keyspace: 'place_directory_development',
      servers: '192.168.0.100:9160',
      thrift: {'timeout' => 10}
    )
    # 
    assert_equal ['192.168.0.100:9160'], TestObject.connection_config.servers
    assert_equal 'place_directory_development', TestObject.connection_config.keyspace
    assert_equal 10, TestObject.connection_config.thrift_options[:timeout]
  end

  test 'establish_connection defaults' do
    TestObject.establish_connection(
      keyspace: 'place_directory_development'
    )

    assert_equal ["127.0.0.1:9160"], TestObject.connection_config.servers
  end
end
