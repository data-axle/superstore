require 'active_support/all'
require 'active_model'
require 'cassandra-cql'

module CassandraObject
  extend ActiveSupport::Autoload

  autoload :AttributeMethods
  autoload :Base
  autoload :BelongsTo
  autoload :Callbacks
  autoload :Connection
  autoload :Consistency
  autoload :Core
  autoload :Identity
  autoload :Inspect
  autoload :Persistence
  autoload :Savepoints
  autoload :Schema
  autoload :Scope
  autoload :Scoping
  autoload :Serialization
  autoload :Timestamps
  autoload :Type
  autoload :Validations

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
