require 'set'

require 'superstore/types'

module Superstore
  class Base

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker
    include ActiveModel::Serializers::JSON
    include GlobalID::Identification

    include Model
    include Core
    include Connection
    include Identity
    include Inspect
    include Persistence
    include AttributeMethods
    include Validations
    include AttributeMethods::Dirty
    include AttributeMethods::PrimaryKey
    include AttributeMethods::Typecasting
    include Associations
    include Callbacks
    include Timestamps
    include Scoping
    include Caching

  end
end

ActiveSupport.run_load_hooks(:superstore, Superstore::Base)
