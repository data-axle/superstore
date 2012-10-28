require 'test_helper'

class CassandraObject::SchemaTest < CassandraObject::TestCase
  test "create_column_family" do
    CassandraObject::Schema.create_column_family 'TestRecords', 'compression_parameters:sstable_compression' => 'SnappyCompressor'

    begin
      CassandraObject::Schema.create_column_family 'TestRecords'
      assert false, 'TestRecords should already exist'
    rescue Exception => e
    end
  end
end
