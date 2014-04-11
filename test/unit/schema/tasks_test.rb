require 'test_helper'

class Superstore::Schema::TasksTest < Superstore::TestCase
  test "table_names" do
    assert_equal ['Issues'], Superstore::Schema.table_names
  end

  test "dump" do
    io = StringIO.new

    Superstore::Schema.dump(io)
    io.rewind

    assert_match /Issues/, io.read
  end

  test "load" do
    Superstore::Schema.expects(:keyspace_execute).with("DO STUFF;")
    Superstore::Schema.expects(:keyspace_execute).with("AND MORE;")

    Superstore::Schema.load StringIO.new(
      "DO\n" +
      " STUFF;\n" +
      "\n" +
      "AND\n" +
      " MORE;\n"
    )
  end
end
