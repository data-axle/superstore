require 'test_helper'

class Superstore::SchemaTest < Superstore::TestCase
  # SELECT columnfamily_name FROM System.schema_columnfamilies WHERE keyspace_name='myKeyspaceName';
  test "create_table" do
    Superstore::Schema.create_table 'TestRecords', 'compression_parameters:sstable_compression' => 'SnappyCompressor'

    begin
      Superstore::Schema.create_table 'TestRecords'
      assert false, 'TestRecords should already exist'
    rescue Exception => e
    end
  end

  test "drop_table" do
    Superstore::Schema.create_table 'TestCFToDrop'

    Superstore::Schema.drop_table 'TestCFToDrop'

    begin
      Superstore::Schema.drop_table 'TestCFToDrop'
      assert false, 'TestCFToDrop should not exist'
    rescue Exception => e
    end
  end

end
