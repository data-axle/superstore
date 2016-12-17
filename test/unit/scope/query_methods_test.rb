require 'test_helper'

class Superstore::Scope::QueryMethodsTest < Superstore::TestCase
  test "select" do
    original_issue = Issue.create title: "foo", comments: [{"text" => "cool"}], description: 'bar'
    found_issue = Issue.select(:title, :comments).find(original_issue.id)

    assert_equal 'foo', found_issue.title
    assert_equal [{"text" => "cool"}], found_issue.comments
    assert_equal original_issue.id, found_issue.id
    assert_nil found_issue.description
  end

  test "where" do
    foo_issue = Issue.create title: 'foo'
    bar_issue = Issue.create title: 'bar'
    nil_issue = Issue.create title: nil

    assert_equal [foo_issue], Issue.where(title: 'foo')
    assert_equal [foo_issue, bar_issue], Issue.where(title: ['foo', 'bar'])
    assert_equal [nil_issue], Issue.where(title: nil)
  end

  test "select with block" do
    foo_issue = Issue.create title: 'foo'
    Issue.create title: 'bar'

    assert_equal [foo_issue], Issue.select { |issue| issue.title == 'foo' }
  end

  test "chaining where with scope" do
    issue = Issue.create title: 'abc', description: 'def'
    query = Issue.select(:title).for_key(issue.id)

    assert_equal [:title], query.select_values
  end
end
