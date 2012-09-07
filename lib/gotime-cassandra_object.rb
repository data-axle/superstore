require 'active_support/all'
require 'active_model'
require 'cassandra-cql'

module CassandraObject
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Connection
  autoload :Consistency
  autoload :AttributeMethods
  autoload :BelongsTo
  autoload :Persistence
  autoload :Callbacks
  autoload :Validations
  autoload :Identity
  autoload :Inspect
  autoload :Serialization
  autoload :Savepoints
  autoload :Schema
  autoload :Scope
  autoload :Scoping
  autoload :Timestamps
  autoload :Type

  module BelongsTo
    extend ActiveSupport::Autoload

    autoload :Association
    autoload :Builder
    autoload :Reflection
  end

  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Definition
      autoload :Dirty
      autoload :PrimaryKey
      autoload :Typecasting
    end
  end

  module Types
    extend ActiveSupport::Autoload
    
    autoload :BaseType
    autoload :ArrayType
    autoload :BooleanType
    autoload :DateType
    autoload :FloatType
    autoload :IntegerType
    autoload :JsonType
    autoload :StringType
    autoload :TimeType
  end
end

require 'cassandra_object/railtie' if defined?(Rails)