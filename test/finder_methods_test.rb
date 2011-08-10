require 'test_helper'

class CassandraObject::FinderMethodsTest < CassandraObject::TestCase
  test 'find' do
    Issue.create.tap do |issue|
      assert_equal issue, Issue.find(issue.id)
    end

    assert_raise CassandraObject::RecordNotFound do
      Issue.find('what')
    end
  end

  test 'find_by_id' do
    Issue.create.tap do |issue|
      assert_equal issue, Issue.find_by_id(issue.id)
    end

    assert_nil Issue.find_by_id('what')
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