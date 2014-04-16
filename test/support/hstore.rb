Bundler.require :hstore
require 'active_record'

Superstore::Base.config = {'adapter' => 'hstore'}

class PGInitializer
  def self.initialize!
    config = {
      'adapter'   => 'postgresql',
      'encoding'  => 'unicode',
      'database'  => 'superstore_test',
      'pool'      => 5,
      'username' => 'postgres'
    }

    ActiveRecord::Base.configurations = { test: config }

    ActiveRecord::Tasks::DatabaseTasks.drop config
    ActiveRecord::Tasks::DatabaseTasks.create config
    ActiveRecord::Base.establish_connection config

    Superstore::Base.adapter.create_table('issues')
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