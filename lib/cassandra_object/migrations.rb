module CassandraObject
  module Migrations
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    included do
      class_inheritable_array :migrations
      class_inheritable_accessor :current_schema_version
      self.current_schema_version = 0
    end

    autoload :Migration
    
    class MigrationNotFoundError < StandardError
      def initialize(record_version, migrations)
        super("Cannot migrate a record from #{record_version.inspect}.  Migrations exist for #{migrations.map(&:version)}")
      end
    end
    
    module InstanceMethods
      def schema_version
        Integer(@schema_version || self.class.current_schema_version)
      end
    end
    
    module ClassMethods
      def migrate(version, &blk)
        write_inheritable_array(:migrations, [Migration.new(version, blk)])
        
        if version > self.current_schema_version 
          self.current_schema_version = version
        end
      end
    end
  end
end
