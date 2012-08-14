require 'test_helper'

class CassandraObject::Schema::TasksTest < CassandraObject::TestCase
  test "column_families" do
    assert_equal ['Issues'], CassandraObject::Schema.column_families
  end
end