require 'test_helper'

class Superstore::CassandraSchema::StatementsTest < Superstore::TestCase
  if Superstore::Base.adapter.is_a?(Superstore::Adapters::CassandraAdapter)
    test "create_keyspace" do
      Superstore::CassandraSchema.create_keyspace 'Blah'

      existing_keyspace = false
      begin
        Superstore::CassandraSchema.create_keyspace 'Blah'
      rescue Exception => e
        existing_keyspace = true
      ensure
        Superstore::CassandraSchema.drop_keyspace 'Blah'
      end

      assert existing_keyspace
    end

    test "add_index" do
      begin
        Superstore::CassandraSchema.create_table 'TestIndexed'
        Superstore::CassandraSchema.alter_column_family 'TestIndexed', "ADD id_value varchar"
        Superstore::CassandraSchema.add_index 'TestIndexed', 'id_value'
      ensure
        Superstore::CassandraSchema.drop_table 'TestIndexed'
      end
    end

    test "drop_index" do
      begin
        Superstore::CassandraSchema.create_table 'TestDropIndexes'

        Superstore::CassandraSchema.alter_column_family 'TestDropIndexes', "ADD id_value1 varchar"
        Superstore::CassandraSchema.alter_column_family 'TestDropIndexes', "ADD id_value2 varchar"

        Superstore::CassandraSchema.add_index 'TestDropIndexes', 'id_value1'
        Superstore::CassandraSchema.add_index 'TestDropIndexes', 'id_value2', 'special_name'

        Superstore::CassandraSchema.drop_index 'TestDropIndexes_id_value1_idx'
        Superstore::CassandraSchema.drop_index 'special_name'
      ensure
        Superstore::CassandraSchema.drop_table 'TestDropIndexes'
      end
    end
  end
end