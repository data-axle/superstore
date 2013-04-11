require 'set'

require 'cassandra_object/log_subscriber'
require 'cassandra_object/types'

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
        class_of_active_record_descendant(self)
      end

      def config=(config)
        @@config = config.is_a?(Hash) ? CassandraObject::Config.new(config) : config
      end

      def config
        @@config
      end

      private

        # Returns the class descending directly from ActiveRecord::Base or an
        # abstract class, if any, in the inheritance hierarchy.
        def class_of_active_record_descendant(klass)
          if klass == Base || klass.superclass == Base
            klass
          elsif klass.superclass.nil?
            raise "#{name} doesn't belong in a hierarchy descending from CassandraObject"
          else
            class_of_active_record_descendant(klass.superclass)
          end
        end
    end

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker

    include Connection
    include Consistency
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
    include Savepoints
    include Scoping
    include Core

    include Serialization
  end
end

ActiveSupport.run_load_hooks(:cassandra_object, CassandraObject::Base)
