require 'test_helper'

class CassandraObject::SchemaTest < CassandraObject::TestCase
  test "create_keyspace" do
    CassandraObject::Schema.create_keyspace 'Blah'

    existing_keyspace = false
    begin
      CassandraObject::Schema.create_keyspace 'Blah'
    rescue Exception => e
      existing_keyspace = true
    ensure
      CassandraObject::Schema.drop_keyspace 'Blah'
    end

    assert existing_keyspace
  end

  test "create_column_family" do
    CassandraObject::Schema.create_column_family 'TestRecords', 'compression_parameters:sstable_compression' => 'SnappyCompressor'

    begin
      CassandraObject::Schema.create_column_family 'TestRecords'
      assert false, 'TestRecords should already exist'
    rescue Exception => e
    end
  end

  test "drop_column_family" do
    CassandraObject::Schema.create_column_family 'TestCFToDrop'

    CassandraObject::Schema.drop_column_family 'TestCFToDrop'

    begin
      CassandraObject::Schema.drop_column_family 'TestCFToDrop'
      assert false, 'TestCFToDrop should not exist'
    rescue Exception => e
    end
  end

  test "create_index" do
    CassandraObject::Schema.create_column_family 'TestIndexed'

    CassandraObject::Schema.alter_column_family 'TestIndexed', "ADD id_value varchar"

    CassandraObject::Schema.add_index 'TestIndexed', 'id_value'
  end

  test "drop_index" do
    CassandraObject::Schema.create_column_family 'TestDropIndexes'

    CassandraObject::Schema.alter_column_family 'TestDropIndexes', "ADD id_value1 varchar"
    CassandraObject::Schema.alter_column_family 'TestDropIndexes', "ADD id_value2 varchar"

    CassandraObject::Schema.add_index 'TestDropIndexes', 'id_value1'
    CassandraObject::Schema.add_index 'TestDropIndexes', 'id_value2', 'special_name'

    CassandraObject::Schema.drop_index 'TestDropIndexes_id_value1_idx'
    CassandraObject::Schema.drop_index 'special_name'
  end

end
