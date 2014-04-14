require 'test_helper'

class Superstore::CassandraSchema::TasksTest < Superstore::TestCase
  if Superstore::Base.adapter.is_a?(Superstore::Adapters::CassandraAdapter)
    test "table_names" do
      assert_equal ['Issues'], Superstore::CassandraSchema.table_names
    end

    test "dump" do
      io = StringIO.new

      Superstore::CassandraSchema.dump(io)
      io.rewind

      assert_match /Issues/, io.read
    end

    test "load" do
      Superstore::CassandraSchema.expects(:keyspace_execute).with("DO STUFF;")
      Superstore::CassandraSchema.expects(:keyspace_execute).with("AND MORE;")

      Superstore::CassandraSchema.load StringIO.new(
        "DO\n" +
        " STUFF;\n" +
        "\n" +
        "AND\n" +
        " MORE;\n"
      )
    end
  end
end
