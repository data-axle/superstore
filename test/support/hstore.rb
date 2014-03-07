Bundler.require :hstore
require 'active_record'
CassandraObject::Base.config = {'adapter' => 'hstore'}
class PGInitializer
  def self.initialize!
    config = {
      'adapter'   => 'postgresql',
      'encoding'  => 'unicode',
      'database'  => 'cassandra_object_test',
      'pool'      => 5,
      'username' => 'postgres'
    }

    ActiveRecord::Tasks::DatabaseTasks.drop config
    ActiveRecord::Tasks::DatabaseTasks.create config
    ActiveRecord::Base.establish_connection config

    ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS hstore'

    table_names.each { |table_name| create_document_table(table_name) }
  end

  def self.create_document_table(table_name)
    ActiveRecord::Migration.create_table table_name, id: false do |t|
      t.string :id, null: false
      t.hstore :attribute_store, null: false
    end
    ActiveRecord::Base.connection.execute "ALTER TABLE #{table_name} ADD CONSTRAINT #{table_name}_pkey PRIMARY KEY (id)"
  end

  def self.table_names
    %w(issues)
  end
end

PGInitializer.initialize!

module ActiveSupport
  class TestCase
    teardown do
      PGInitializer.table_names.each do |table_name|
        ActiveRecord::Base.connection.execute "TRUNCATE #{table_name}"
      end
    end
  end
end