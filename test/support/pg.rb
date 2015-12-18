require 'active_record'

class PGInitializer
  def self.initialize!
    config = {
      'adapter'   => 'postgresql',
      'encoding'  => 'unicode',
      'database'  => 'superstore_test',
      'pool'      => 5,
      'host'      => 'localhost'
    }

    ActiveRecord::Base.configurations = { test: config }

    ActiveRecord::Tasks::DatabaseTasks.drop config
    ActiveRecord::Tasks::DatabaseTasks.create config
    ActiveRecord::Base.establish_connection config

    create_labels_table
    create_users_table
  end

  def self.create_labels_table
    ActiveRecord::Migration.create_table :labels do |t|
      t.string :issue_id, null: false
      t.string :name, null: false
    end
  end

  def self.create_users_table
    ActiveRecord::Migration.create_table :users do |t|
      t.string :special_id, null: false
      t.index :special_id, unique: true
    end
  end

  def self.table_names
    %w(labels users)
  end
end

PGInitializer.initialize!
ActiveRecord::Migration.verbose = false