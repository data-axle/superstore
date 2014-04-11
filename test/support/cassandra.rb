Bundler.require :cassandra

Superstore::Base.config = {
  keyspace: 'superstore_test',
  servers: '127.0.0.1:9160',
  thrift: {
    timeout: 5
  }
}

begin
  Superstore::Schema.drop_keyspace 'superstore_test'
rescue Exception => e
end

sleep 1
Superstore::Schema.create_keyspace 'superstore_test'
Superstore::Schema.create_column_family 'Issues'
Superstore::Base.adapter.consistency = 'QUORUM'

Superstore::Base.class_eval do
  class_attribute :created_records
  self.created_records = []

  after_create do
    created_records << self
  end

  def self.delete_after_test
    # created_records.reject(&:destroyed?).each(&:destroy)
    Issue.delete_all
    created_records.clear
  end
end

module ActiveSupport
  class TestCase
    teardown do
      if Superstore::Base.created_records.any?
        Superstore::Base.delete_after_test
      end
    end
  end
end
