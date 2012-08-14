require 'test_helper'

class CassandraObject::Schema::TasksTest < CassandraObject::TestCase
  test "column_families" do
    assert_equal ['Issues'], CassandraObject::Schema.column_families
  end

  test "dump" do
    io = StringIO.new

    CassandraObject::Schema.dump(io)
    io.rewind

    assert_match /Issues/, io.read
  end
end
