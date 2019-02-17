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
    include Persistence
    include ActiveRecord::ReadonlyAttributes
    include ModelSchema
    include Inheritance
    include ActiveRecord::Scoping
    include ActiveRecord::Sanitization
    include AttributeAssignment
    include ActiveRecord::Integration
    include ActiveRecord::Validations
    include Attributes
    include ActiveRecord::AttributeDecorators
    include ActiveRecord::DefineCallbacks
    include AttributeMethods
    include ActiveRecord::Callbacks
    include Timestamp
    include Associations
    include ActiveRecord::AutosaveAssociation
    include ActiveRecord::Reflection
    include ActiveRecord::Transactions

    include Core
    include Connection
    include Identity
    include Inspect
  end
end

ActiveSupport.run_load_hooks(:superstore, Superstore::Base)
