require "test_helper"

class CassandraObject::ConsistencyTest < CassandraObject::TestCase
  test "with_consistency" do
    original = CassandraObject::Base.default_consistency

    CassandraObject::Base.with_consistency 'LOL' do
      assert_equal 'LOL', CassandraObject::Base.default_consistency
    end

    assert_equal original, CassandraObject::Base.default_consistency
  end
end