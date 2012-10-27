require 'test_helper'

class CassandraObject::FinderMethodsTest < CassandraObject::TestCase
  test 'find' do
    Issue.create.tap do |issue|
      assert_equal issue, Issue.find(issue.id)
    end

    begin
      Issue.find(nil)
      assert false
    rescue => e
      assert_equal "Couldn't find Issue with key nil", e.message
    end

    assert_raise CassandraObject::RecordNotFound do
      Issue.find('what')
    end
  end

  test 'find with ids' do
    first_issue = Issue.create
    second_issue = Issue.create
    third_issue = Issue.create

    assert_equal [], Issue.find([])
    assert_equal [first_issue, second_issue], Issue.find([first_issue.id, second_issue.id])
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
end
