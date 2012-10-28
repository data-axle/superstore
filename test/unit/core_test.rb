require 'test_helper'

class CassandraObject::CoreTest < CassandraObject::TestCase
  test 'initialiaze' do
    issue = Issue.new

    assert issue.new_record?
    assert !issue.destroyed?
  end

  test 'dup' do
    issue = Issue.create description: 'foo'

    dup_issue = issue.dup

    assert dup_issue.new_record?
    assert_not_equal issue.id, dup_issue.id
    assert_nil dup_issue.created_at
    assert_nil dup_issue.updated_at
    assert_equal 'foo', issue.description
  end

  test 'equality of new records' do
    assert_not_equal Issue.new, Issue.new
  end

  test 'equality' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert_equal first_issue, first_issue
    assert_equal first_issue, Issue.find(first_issue.id)
    assert_not_equal first_issue, second_issue
  end

  test 'to_param' do
    issue = Issue.new
    assert_equal issue.id, issue.to_param
  end

  test 'hash' do
    issue = Issue.create
    assert_equal issue.id.hash, issue.hash
  end
end
