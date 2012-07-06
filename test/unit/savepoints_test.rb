require 'test_helper'

class CassandraObject::SavepointsTest < CassandraObject::TestCase
  test 'rollback create' do
    Issue.savepoint do
      issue = Issue.create description: 'foo'
      raise 'lol'
    end
    
    assert_nil Issue.first
  end
  
  test 'rollback update' do
    issue = Issue.create description: 'foo'
  
    Issue.savepoint do
      issue.update_attributes description: 'bar'
      raise 'lol'
    end
    
    issue = Issue.find issue.id
    assert_equal 'foo', issue.description
  end

  test 'rollback destroy' do
    issue = Issue.create description: 'foo'
  
    Issue.savepoint do
      issue.destroy
      raise 'lol'
    end
    
    assert_nothing_raised { Issue.find issue.id }
  end
end