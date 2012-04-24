require 'test_helper'

class CassandraObject::Tasks::ColumnFamilyTest < CassandraObject::TestCase
  setup do
    column_family_task.drop('Gadgets') if column_family_task.exists?('Gadgets')
    column_family_task.drop('Widgets') if column_family_task.exists?('Widgets')
  end

  test 'create' do
    assert !column_family_task.exists?('Widgets')
    column_family_task.create 'Widgets'
    assert column_family_task.exists?('Widgets')
  end

  # test 'rename' do
  #   column_family_task.create 'Widgets'
  #   column_family_task.rename 'Widgets', 'Gadgets'
  # 
  #   sleep 2
  # 
  #   assert !column_family_task.exists?('Widgets')
  #   assert column_family_task.exists?('Gadgets')
  # end

  private
    def column_family_task
      @column_family_task ||= CassandraObject::Tasks::ColumnFamily.new(CassandraObject::Base.connection.keyspace)
    end
end