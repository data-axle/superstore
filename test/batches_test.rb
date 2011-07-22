require 'test_helper'

class CassandraObject::BatchesTest < CassandraObject::TestCase
  test 'hola' do
    Issue.create 
    Issue.create 
    p "Issue.all = #{Issue.all}"
    # Issue.find_each do |issue|
    #   p "issue = #{issue.inspect}"
    # end
  end

  test 'find_in_batches' do
    Issue.create 
    Issue.create

    # Issue.find_in_batches(batch_size: 1) do |batch|
    #   assert_kind_of Array, batch
    #   assert_equal 1, batch.size
    #   assert_kind_of Issue, batch.first
    # end
  end
end