require 'test_helper'

class Superstore::SchemaTest < Superstore::TestCase
  test "create_keyspace" do
    Superstore::Schema.create_keyspace 'Blah'

    existing_keyspace = false
    begin
      Superstore::Schema.create_keyspace 'Blah'
    rescue Exception => e
      existing_keyspace = true
    ensure
      Superstore::Schema.drop_keyspace 'Blah'
    end

    assert existing_keyspace
  end

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

  test "create_index" do
    Superstore::Schema.create_column_family 'TestIndexed'

    Superstore::Schema.alter_column_family 'TestIndexed', "ADD id_value varchar"

    Superstore::Schema.add_index 'TestIndexed', 'id_value'
  end

  test "drop_index" do
    Superstore::Schema.create_column_family 'TestDropIndexes'

    Superstore::Schema.alter_column_family 'TestDropIndexes', "ADD id_value1 varchar"
    Superstore::Schema.alter_column_family 'TestDropIndexes', "ADD id_value2 varchar"

    Superstore::Schema.add_index 'TestDropIndexes', 'id_value1'
    Superstore::Schema.add_index 'TestDropIndexes', 'id_value2', 'special_name'

    Superstore::Schema.drop_index 'TestDropIndexes_id_value1_idx'
    Superstore::Schema.drop_index 'special_name'
  end

end
