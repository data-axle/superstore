require 'active_record'

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

    create_users_table
  end

  def self.create_users_table
    ActiveRecord::Migration.create_table :users do |t|
      t.string :special_id, null: false
      t.index :special_id, unique: true
    end
  end

  def self.table_names
    %w(users)
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
