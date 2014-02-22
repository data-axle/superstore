require 'test_helper'

class CassandraObject::Schema::TasksTest < CassandraObject::TestCase
  test "table_names" do
    assert_equal ['Issues'], CassandraObject::Schema.table_names
  end

  test "dump" do
    io = StringIO.new

    CassandraObject::Schema.dump(io)
    io.rewind

    assert_match /Issues/, io.read
  end

  test "load" do
    CassandraObject::Schema.expects(:keyspace_execute).with("DO STUFF;")
    CassandraObject::Schema.expects(:keyspace_execute).with("AND MORE;")

    CassandraObject::Schema.load StringIO.new(
      "DO\n" +
      " STUFF;\n" +
      "\n" +
      "AND\n" +
      " MORE;\n"
    )
  end
end
