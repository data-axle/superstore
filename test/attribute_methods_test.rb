require 'test_helper'

class CassandraObject::AttributeMethodsTest < CassandraObject::TestCase
  class CustomType
  end
  
  class CustomCoder < CassandraObject::Types::BaseType
  end

  class TestIssue < CassandraObject::Base
    key :uuid
    self.column_family = 'Issues'

    attribute :custom_column, type: CustomType, coder: CustomCoder
    integer :price
    json :orders
  end

  class TestChildIssue < TestIssue
    string :description
  end

  test 'custom attribute definer' do
    model_attribute = TestIssue.attribute_definitions[:custom_column]

    assert_kind_of CustomCoder, model_attribute.coder
    assert_equal CustomType, model_attribute.expected_type
  end

  test 'json attribute' do
    issue = TestIssue.create! orders: {'a' => 'b'}

    issue = TestIssue.find issue.id

    assert_equal({'a' => 'b'}, issue.orders)
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
