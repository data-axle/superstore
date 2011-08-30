require 'active_support/all'
require 'active_model'

module CassandraObject
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Connection
  autoload :AttributeMethods
  autoload :Consistency
  autoload :Persistence
  autoload :Callbacks
  autoload :Validations
  autoload :Identity
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

  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Definition
      autoload :Dirty
    end
  end

  module Tasks
    extend ActiveSupport::Autoload
    autoload :Keyspace
    autoload :ColumnFamily
  end

  module Types
    extend ActiveSupport::Autoload
    
    autoload :BaseType
    autoload :ArrayType
    autoload :BooleanType
    autoload :DateType
    autoload :FloatType
    autoload :HashType
    autoload :IntegerType
    autoload :StringType
    autoload :TimeType
    autoload :TimeWithZoneType
  end
end

require 'cassandra_object/railtie' if defined?(Rails)