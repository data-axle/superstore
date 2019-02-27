require 'superstore/types'

module Superstore
  class Base < ActiveRecord::Base

    self.connection_specification_name = 'primary'
    self.abstract_class                = true
    include Core
    include Persistence
    include ModelSchema
    include AttributeAssignment
    include Attributes
    include AttributeMethods
    include Timestamp
    include Associations

    include Identity
  end
end
