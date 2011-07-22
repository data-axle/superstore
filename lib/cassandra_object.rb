require 'rails/all'

module CassandraObject
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Connection
  autoload :Attributes
  autoload :Dirty
  autoload :Consistency
  autoload :Persistence
  autoload :Callbacks
  autoload :Validation
  autoload :Identity
  autoload :Indexes
  autoload :Serialization
  autoload :Associations
  autoload :Migrations
  autoload :Cursor
  autoload :Collection
  autoload :Types
  autoload :Mocking
  autoload :Batches
  autoload :FinderMethods
  autoload :Timestamps

  autoload :Schema

  module Tasks
    extend ActiveSupport::Autoload
    autoload :Keyspace
    autoload :ColumnFamily
  end
end

require 'cassandra_object/railtie'