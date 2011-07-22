require 'test_helper'

class CassandraObject::FinderMethodsTest < CassandraObject::TestCase
  test 'first' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert [first_issue, second_issue].include?(Issue.first)
  end

  test 'all' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert_equal [first_issue, second_issue].to_set, Issue.all.to_set
  end
end