require 'set'

require 'cassandra_object/log_subscriber'
require 'cassandra_object/types'
require 'cassandra_object/errors'

module CassandraObject
  class Base
    class << self
      def column_family=(column_family)
        @column_family = column_family
      end

      def column_family
        @column_family || name.pluralize
      end

      def base_class
        klass = self
        while klass.superclass != Base
          klass = klass.superclass
        end
        klass
      end
    end

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker
    
    include Connection
    include Consistency
    include Identity
    include Attributes
    include Persistence
    include Callbacks
    include Dirty
    include Validations
    include Associations
    include Batches
    include FinderMethods
    include Timestamps

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

    def to_param
      id.to_s if persisted?
    end

    def hash
      id.hash
    end    

    def ==(comparison_object)
      comparison_object.equal?(self) ||
        (comparison_object.instance_of?(self.class) &&
          comparison_object.key == key &&
          !comparison_object.new_record?)
    end

    def eql?(comparison_object)
      self == (comparison_object)
    end
  end
end
