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

  test "load" do
    CassandraObject::Base.expects(:execute_cql).with("DO STUFF;")
    CassandraObject::Base.expects(:execute_cql).with("AND MORE;")

    CassandraObject::Schema.load StringIO.new(
      "DO\n" +
      " STUFF;\n" +
      "\n" +
      "AND\n" +
      " MORE;\n"
    )
  end
end
