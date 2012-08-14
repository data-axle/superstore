require 'test_helper'

class CassandraObject::QueryMethodsTest < CassandraObject::TestCase
  test "select" do
    issue = Issue.create title: 'foo', description: 'bar'

    issue = Issue.select(:title).find(issue.id)

    assert_equal 'foo', issue.title
    assert_nil issue.description
  end
end