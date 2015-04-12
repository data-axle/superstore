Bundler.require :hstore
Superstore::Base.config = {'adapter' => 'hstore'}

class HstoreInitializer
  def self.initialize!
    Superstore::Base.adapter.create_table('issues')
  end

  def self.table_names
    %w(issues)
  end
end

HstoreInitializer.initialize!

module ActiveSupport
  class TestCase
    teardown do
      HstoreInitializer.table_names.each do |table_name|
        ActiveRecord::Base.connection.execute "TRUNCATE #{table_name}"
      end
    end
  end
end