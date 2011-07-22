require 'test_helper'

class CassandraObject::PersistenceTest < CassandraObject::TestCase
  test 'persisted' do
    issue = Issue.new
    assert issue.new_record?
    assert !issue.persisted?

    issue.save
    assert issue.persisted?
    assert !issue.new_record?

    issue.destroy
    assert issue.destroyed?
    assert !issue.persisted?
  end
end