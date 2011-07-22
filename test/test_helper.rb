require 'cassandra_object'
require 'rails/test_help'

class Issue < CassandraObject::Base
  key :uuid
end

module CassandraObject
  class TestCase < ActiveSupport::TestCase
    setup do
      CassandraObject::Base.establish_connection(
        keyspace: 'place_directory_development',
        servers: '192.168.0.100:9160'
      )
    end

    teardown do
      Issue.delete_all
    end

    def connection
      CassandraObject::Base.connection
    end
  end
end