require 'set'

require 'superstore/log_subscriber'
require 'superstore/types'

module Superstore
  class Base

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker
    include ActiveModel::Serializers::JSON

    include Connection
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
    include Scoping
    include Core
    include Caching
    extend  Model

  end
end

ActiveSupport.run_load_hooks(:superstore, Superstore::Base)
