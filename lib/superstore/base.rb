require 'set'

require 'superstore/types'

module Superstore
  class Base

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker
    include ActiveModel::Serializers::JSON
    include GlobalID::Identification

    extend ActiveRecord::ConnectionHandling
    self.connection_specification_name = 'primary'
    extend ActiveRecord::Querying
    extend ActiveRecord::Delegation::DelegateCache
    include ActiveRecord::Core
    include ActiveRecord::Persistence
    include ActiveRecord::ModelSchema
    include ActiveRecord::Inheritance
    include ActiveRecord::Scoping
    include ActiveRecord::Sanitization
    include ActiveRecord::Integration
    # include ActiveRecord::Validations
    include ActiveRecord::Attributes
    # include ActiveRecord::Callbacks
    include ActiveRecord::Associations
    include ActiveRecord::AutosaveAssociation
    include ActiveRecord::Reflection

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
    include Caching

  end
end

ActiveSupport.run_load_hooks(:superstore, Superstore::Base)
