require 'test_helper'

class CassandraObject::FinderMethodsTest < CassandraObject::TestCase
  test 'find' do
    persisted_issue = Issue.create
    found_issue = Issue.find(persisted_issue.id)

    assert_equal persisted_issue, found_issue
  end

  test 'find missing record' do
    assert_raise CassandraObject::RecordNotFound do
      Issue.find('what')
    end
  end

  test 'all' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert_equal [first_issue, second_issue].to_set, Issue.all.to_set
  end

  test 'first' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert [first_issue, second_issue].include?(Issue.first)
  end

  test 'find_with_ids' do
    first_issue = Issue.create
    second_issue = Issue.create
    third_issue = Issue.create

    assert_equal [], Issue.find_with_ids([])
    assert_equal first_issue, Issue.find_with_ids(first_issue.key)
    assert_equal [first_issue, second_issue].to_set, Issue.find_with_ids(first_issue.key, second_issue.key).to_set
    assert_equal [first_issue, second_issue].to_set, Issue.find_with_ids([first_issue.key, second_issue.key]).to_set
  end

  # test 'find single id' do
  #   created_issue = Issue.create
  # 
  #   found_issue = Issue.find(created_issue.id)
  # 
  #   assert_equal created_issue, found_issue
  # end
end