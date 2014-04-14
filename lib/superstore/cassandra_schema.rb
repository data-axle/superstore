require 'superstore/cassandra_schema/statements'
require 'superstore/cassandra_schema/tasks'

module Superstore
  class CassandraSchema < Schema
    extend Superstore::Statements
    extend Superstore::Tasks
  end
end