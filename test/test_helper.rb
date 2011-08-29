require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'cassandra/0.8'
require 'gotime-cassandra_object'

CassandraObject::Base.establish_connection(
  keyspace: 'place_directory_development',
  servers: '127.0.0.1:9160'
)

class Issue < CassandraObject::Base
  key :uuid
  string :description
end

module CassandraObject
  class TestCase < ActiveSupport::TestCase
    setup do
    end

    teardown do
      Issue.delete_all
    end

    def connection
      CassandraObject::Base.connection
    end
  end

  module Types
    class TestCase < CassandraObject::TestCase
      attr_accessor :coder
      setup do
        @coder = self.class.name.sub(/Test$/, '').constantize.new
      end
    end
  end
end