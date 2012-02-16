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
        @column_family ||= base_class.name.pluralize
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
    include Inspect
    include FinderMethods
    include Persistence
    include Batches
    include AttributeMethods
    include AttributeMethods::Dirty
    include AttributeMethods::Typecasting
    include BelongsTo
    include Validations
    include Callbacks
    include Timestamps

    attr_reader :attributes

    include Serialization
    include Migrations
    include Mocking

    def initialize(attributes={})
      @key = attributes.delete(:key)
      @new_record = true
      @destroyed = false
      @attributes = {}
      self.attributes = attributes
      attribute_definitions.each do |attr, attribute_definition|
        unless attribute_exists?(attr)
          self.attributes[attr.to_s] = self.class.typecast_attribute(self, attr, nil)
        end
      end

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
          comparison_object.id == id)
    end

    def eql?(comparison_object)
      self == (comparison_object)
    end
  end
end

ActiveSupport.run_load_hooks(:cassandra_object, CassandraObject::Base)