require 'test_helper'

class CassandraObject::AttributesTest < CassandraObject::TestCase
  class TestIssue < CassandraObject::Base
    self.column_family = 'Issue'
  end

  class TestChildIssue < TestIssue
    attribute :description, type: :string
  end

  test 'attributes not shared' do
    assert_nothing_raised { Issue.new.description }
    assert_raise(NoMethodError) { TestIssue.new.description }
    assert_nothing_raised { TestChildIssue.new.description }
  end

  test 'attributes setter' do
    issue = Issue.new

    issue.attributes = {
      description: 'foo'
    }

    assert_equal 'foo', issue.description
  end
end