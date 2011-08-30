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
    teardown do
      Issue.delete_all
    end
    
    def connection
      CassandraObject::Base.connection
    end

    def temp_object(&block)
      Class.new(CassandraObject::Base) do
        key :uuid
        self.column_family = 'Issues'
        instance_eval(&block)
      end
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