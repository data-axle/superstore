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
