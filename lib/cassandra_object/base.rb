require 'set'

require 'cassandra_object/log_subscriber'
require 'cassandra_object/types'

module CassandraObject
  class Base

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker

    include Connection
    include Consistency
    include Identity
    include Inspect
    include Persistence
    include AttributeMethods
    include Validations
    include AttributeMethods::Dirty
    include AttributeMethods::PrimaryKey
    include AttributeMethods::Typecasting
    include BelongsTo
    include Callbacks
    include Timestamps
    include Savepoints
    include Scoping
    include Core
    extend  Model

    include Serialization
  end
end

ActiveSupport.run_load_hooks(:cassandra_object, CassandraObject::Base)
