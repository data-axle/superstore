require 'test_helper'

class CassandraObject::Scope::QueryMethodsTest < CassandraObject::TestCase
  test "select" do
    issue = Issue.create title: 'foo', description: 'bar'

    issue = Issue.select(:title).find(issue.id)

    assert_equal 'foo', issue.title
    assert_nil issue.description
  end

  test "select with block" do
    foo_issue = Issue.create title: 'foo'
    bar_issue = Issue.create title: 'bar'

    assert_equal [foo_issue], Issue.select { |issue| issue.title == 'foo' }
  end
end