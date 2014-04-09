require 'active_support/all'
require 'active_model'
require 'cassandra_object/errors'

module CassandraObject
  extend ActiveSupport::Autoload

  autoload :AttributeMethods
  autoload :Base
  autoload :BelongsTo
  autoload :Callbacks
  autoload :Connection
  autoload :Core
  autoload :Identity
  autoload :Inspect
  autoload :Model
  autoload :Persistence
  autoload :Schema
  autoload :Scope
  autoload :Scoping
  autoload :Serialization
  autoload :Timestamps
  autoload :Type
  autoload :Validations

  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Definition
      autoload :Dirty
      autoload :PrimaryKey
      autoload :Typecasting
    end
  end

  module Adapters
    extend ActiveSupport::Autoload

    autoload :AbstractAdapter
    autoload :CassandraAdapter
    autoload :HstoreAdapter
  end

  module BelongsTo
    extend ActiveSupport::Autoload

    autoload :Association
    autoload :Builder
    autoload :Reflection
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
