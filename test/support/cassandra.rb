CassandraObject::Base.config = {
  keyspace: 'cassandra_object_test',
  servers: '127.0.0.1:9160',
  thrift: {
    timeout: 5
  }
}

begin
  CassandraObject::Schema.drop_keyspace 'cassandra_object_test'
rescue Exception => e
end

sleep 1
CassandraObject::Schema.create_keyspace 'cassandra_object_test'
CassandraObject::Schema.create_column_family 'Issues'
CassandraObject::Base.adapter.consistency = 'QUORUM'

CassandraObject::Base.class_eval do
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
      if CassandraObject::Base.created_records.any?
        CassandraObject::Base.delete_after_test
      end
    end
  end
end
