require 'cassandra/0.8'
require 'set'

require 'cassandra_object/log_subscriber'

module CassandraObject
  class Base
    module Naming
      def column_family=(column_family)
        @column_family = column_family
      end

      def column_family
        @column_family || name.pluralize
      end
    end
    extend Naming

    class << self
      def base_class
        klass = self
        while klass.superclass != Base
          klass = klass.superclass
        end
        klass
      end
    end

    extend ActiveModel::Naming
    extend ActiveSupport::DescendantsTracker
    
    include Connection
    include Callbacks
    include Identity
    include Attributes
    include Persistence
    include Indexes
    include Dirty
    include Validation
    include Associations
    include Batches
    include FinderMethods

    attr_reader :attributes
    attr_accessor :key

    include Serialization
    include Migrations
    include Mocking

    def initialize(attributes={})
      @key = attributes.delete(:key)
      @new_record = true
      @destroyed = false
      @attributes = {}.with_indifferent_access
      self.attributes = attributes
      @schema_version = self.class.current_schema_version
    end

    def to_model
      self
    end
  end
end

require 'cassandra_object/type_registration'
