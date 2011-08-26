require 'test_helper'

class CassandraObject::AttributesTest < CassandraObject::TestCase
  class TestIssue < CassandraObject::Base
    self.column_family = 'Issue'
    integer :price
    array :favorite_colors
    boolean :enabled
  end

  class TestChildIssue < TestIssue
    string :description
  end

  test 'instantiate_attribute' do
    assert_equal 1, TestIssue.instantiate_attribute(TestIssue.new, 'price', 1)
    assert_equal 1, TestIssue.instantiate_attribute(TestIssue.new, :price, 1)

    assert_raise NoMethodError do
      TestIssue.instantiate_attribute(TestIssue.new, 'wtf', 1)
    end
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
