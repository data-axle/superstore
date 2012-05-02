module CassandraObject
  module Migrations
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    included do
      class_attribute :migrations
      self.migrations = []
    end

    autoload :Migration
    
    class MigrationNotFoundError < StandardError
      def initialize(record_version, migrations)
        super("Cannot migrate a record from #{record_version.inspect}.  Migrations exist for #{migrations.map(&:version)}")
      end
    end
    
    module ClassMethods
      def migrate(version, &blk)
        migrations << Migration.new(version, blk)
      end
    end
  end
end
