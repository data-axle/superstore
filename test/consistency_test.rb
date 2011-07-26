require 'test_helper'

class CassandraObject::ConsistencyTest < CassandraObject::TestCase
  class TestModel < CassandraObject::Base
  end

  test 'consistency_levels' do
    assert_equal [:one, :quorum, :all].to_set, TestModel.consistency_levels.to_set
  end

  test 'thrift_write_consistency' do
    TestModel.write_consistency = :all
    assert_equal Cassandra::Consistency::ALL, TestModel.thrift_write_consistency
  end
  
  test 'thrift_read_consistency' do
    TestModel.read_consistency = :all
    assert_equal Cassandra::Consistency::ALL, TestModel.thrift_read_consistency
  end
end