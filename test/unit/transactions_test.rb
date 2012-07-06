require 'test_helper'

class CassandraObject::TransactionsTest < CassandraObject::TestCase
  test 'rollback create' do
    Issue.transaction do
      issue = Issue.create description: 'foo'
      raise 'lol'
    end
    
    assert_nil Issue.first
  end
  
  
  test 'rollback update' do
    issue = Issue.create description: 'foo'
  
    Issue.transaction do
      issue.update_attributes description: 'bar'
      raise 'lol'
    end
    
    issue = Issue.find issue.id
    assert_equal 'foo', issue.description
  end
end