require 'test_helper'

class CassandraObject::AttributeMethods::TypecastingTest < CassandraObject::TestCase
  class CustomType
  end
  
  class CustomCoder < CassandraObject::Types::BaseType
  end

  class TestIssue < CassandraObject::Base
    self.column_family = 'Issues'

    attribute :custom_column, type: CustomType, coder: CustomCoder
    boolean :enabled
    float   :rating
    integer :price
    json    :orders
    string  :name
  end

  class TestChildIssue < TestIssue
    string :description
  end

  test 'attributes not shared' do
    assert_nothing_raised { Issue.new.description }
    assert_raise(NoMethodError) { TestIssue.new.description }
    assert_nothing_raised { TestChildIssue.new.description }
  end

  test 'custom attribute definer' do
    model_attribute = TestIssue.attribute_definitions[:custom_column]

    assert_kind_of CustomCoder, model_attribute.coder
    assert_equal 'custom_column', model_attribute.name
  end

  test 'typecast_attribute' do
    assert_equal 1, TestIssue.typecast_attribute(TestIssue.new, 'price', 1)
    assert_equal 1, TestIssue.typecast_attribute(TestIssue.new, :price, 1)

    assert_raise NoMethodError do
      TestIssue.typecast_attribute(TestIssue.new, 'wtf', 1)
    end
  end

  test 'boolean attribute' do
    issue = TestIssue.create! enabled: '1'
    assert_equal true, issue.enabled

    issue = TestIssue.find issue.id
    assert_equal true, issue.enabled
  end

  test 'float attribute' do
    issue = TestIssue.create! rating: '4.5'
    assert_equal 4.5, issue.rating

    issue = TestIssue.find issue.id
    assert_equal(4.5, issue.rating)
  end

  test 'integer attribute' do
    issue = TestIssue.create! price: '101'
    assert_equal 101, issue.price

    issue = TestIssue.find issue.id
    assert_equal(101, issue.price)
  end

  test 'json attribute' do
    issue = TestIssue.create! orders: {'a' => 'b'}
    assert_equal({'a' => 'b'}, issue.orders)

    issue = TestIssue.find issue.id
    assert_equal({'a' => 'b'}, issue.orders)
  end

  test 'string attribute' do
    issue = TestIssue.create! name: 'hola'
    assert_equal('hola', issue.name)

    issue = TestIssue.find issue.id
    assert_equal('hola', issue.name)
  end
end