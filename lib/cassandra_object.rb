# raise 'wtf!!!'

require 'rubygems'
require 'i18n'
require 'active_support'
require 'active_model'

module CassandraObject
  extend ActiveSupport::Autoload

  autoload :Base
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
  autoload :FindEach
  autoload :FindWithIds
  autoload :Timestamps

  autoload :Migrator
  autoload :Migration  

  module Tasks
    extend ActiveSupport::Autoload
    autoload :Keyspace
    autoload :ColumnFamily

    require 'cassandra_object/tasks/ks'
  end

  module Generators
    require 'cassandra_object/generators/migration_generator'
  end
end
