require 'test_helper'

class CassandraObject::ConfigTest < CassandraObject::TestCase
  test 'config writer' do
    config =  CassandraObject::Config.new(
      keyspace: 'place_directory_development',
      servers: '192.168.0.100:9160',
      thrift: {'timeout' => 10},
      keyspace_options: {'placement_strategy' => 'NetworkTopologyStrategy'}
    )

    assert_equal ['192.168.0.100:9160'], config.servers
    assert_equal 'place_directory_development', config.keyspace
    assert_equal 10, config.thrift_options[:timeout]
    assert_equal 'NetworkTopologyStrategy', config.keyspace_options[:placement_strategy]
  end

  test 'defaults' do
    config = CassandraObject::Config.new(keyspace: 'widget_factory')

    assert_equal ["127.0.0.1:9160"], config.servers
  end
end