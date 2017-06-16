require 'set'
require 'active_record/attributes'
require 'active_record/define_callbacks' if ActiveRecord.version >= Gem::Version.new('5.1.0')
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
    extend ActiveRecord::Translation
    extend ActiveRecord::Delegation::DelegateCache
    include ActiveRecord::Core
    include ActiveRecord::Persistence
    include Persistence
    include ActiveRecord::ReadonlyAttributes
    include ActiveRecord::ModelSchema
    include ActiveRecord::Inheritance
    include ActiveRecord::Scoping
    include ActiveRecord::Sanitization
    include ActiveRecord::Integration
    include ActiveRecord::Validations
    include ActiveRecord::Attributes
    include ActiveRecord::DefineCallbacks if ActiveRecord.version >= Gem::Version.new('5.1.0')
    include ActiveRecord::Callbacks
    include ActiveRecord::Associations
    include ActiveRecord::AutosaveAssociation
    include ActiveRecord::Reflection
    include ActiveRecord::Transactions

    include Model
    include Core
    include Connection
    include Identity
    include Inspect
    include AttributeMethods
    include AttributeMethods::Dirty
    include AttributeMethods::PrimaryKey
    include AttributeMethods::Typecasting
    include Associations
    include Timestamps
    include Caching

  end
end

ActiveSupport.run_load_hooks(:superstore, Superstore::Base)
