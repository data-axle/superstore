require "test_helper"

class CassandraObject::ConsistencyTest < CassandraObject::TestCase
  test "with_consistency" do
    assert_nil CassandraObject::Base.default_consistency

    CassandraObject::Base.with_consistency 'QUORUM' do
      assert_equal 'QUORUM', CassandraObject::Base.default_consistency
    end

    assert_nil CassandraObject::Base.default_consistency
  end
end