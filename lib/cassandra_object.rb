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
  autoload :Validations
  autoload :Identity
  autoload :Indexes
  autoload :Serialization
  autoload :Associations
  autoload :Migrations
  autoload :Cursor
  autoload :Collection
  autoload :Mocking
  autoload :Batches
  autoload :FinderMethods
  autoload :Timestamps
  autoload :Type
  autoload :Schema

  module Tasks
    extend ActiveSupport::Autoload
    autoload :Keyspace
    autoload :ColumnFamily
  end

  module Types
    extend ActiveSupport::Autoload
    
    autoload :ArrayType
    autoload :BooleanType
    autoload :DateType
    autoload :FloatType
    autoload :HashType
    autoload :IntegerType
    autoload :SetType
    autoload :TimeType
    autoload :TimeWithZoneType
    autoload :UTF8StringType
  end
end

require 'cassandra_object/railtie'