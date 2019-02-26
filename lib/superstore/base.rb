require 'set'
require 'superstore/types'

module Superstore
  class Base < ActiveRecord::Base

    self.connection_specification_name = 'primary'
    include Persistence
    include ModelSchema
    include AttributeAssignment
    include Attributes
    include AttributeMethods
    include Timestamp
    include Associations

    include Core
    include Connection
    include Identity
  end
end

ActiveSupport.run_load_hooks(:superstore, Superstore::Base)
