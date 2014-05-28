require 'test_helper'

class Superstore::SchemaTest < Superstore::TestCase
  # SELECT columnfamily_name FROM System.schema_columnfamilies WHERE keyspace_name='myKeyspaceName';
  test "create and drop_table" do
    Superstore::Schema.create_table 'TestRecords'

    begin
      Superstore::Schema.create_table 'TestRecords'
      assert false, 'TestRecords should already exist'
    rescue Exception => e
    end

    Superstore::Schema.drop_table 'TestRecords'

    begin
      Superstore::Schema.drop_table 'TestRecords'
      assert false, 'TestRecords should not exist'
    rescue Exception => e
    end
  end

end
