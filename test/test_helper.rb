require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'cassandra/0.8'
require 'gotime-cassandra_object'

class Issue < CassandraObject::Base
  key :uuid
  attribute :description, type: :string
end

module CassandraObject
  class TestCase < ActiveSupport::TestCase
    setup do
      CassandraObject::Base.establish_connection(
        keyspace: 'place_directory_development',
        # servers: '192.168.0.100:9160'
        servers: '127.0.0.1:9160'
      )
    end

    teardown do
      Issue.delete_all
    end

    def connection
      CassandraObject::Base.connection
    end
  end

  module Types
    class TestCase < ActiveSupport::TestCase
      attr_accessor :coder
      setup do
        @coder = self.class.name.sub(/Test$/, '').constantize.new
      end
    end
  end
end