require 'test_helper'

class Superstore::AttributesTest < Superstore::TestCase
  class TestIssue < Superstore::Base
    self.table_name = 'issues'

    has_id
    attribute :enabled, type: :boolean
    attribute :rating, type: :float
    attribute :price, type: :integer
    attribute :orders, type: :json
    attribute :name, type: :string
    attribute :age_range, type: :integer_range
  end

  class TestChildIssue < TestIssue
    attribute :description, type: :string
  end

  test 'attributes not shared' do
    assert_nothing_raised { Issue.new.description }
    assert_raise(NoMethodError) { TestIssue.new.description }
    assert_nothing_raised { TestChildIssue.new.description }
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

    issue = TestIssue.new price: ''
    assert_nil issue.price
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

    issue = TestIssue.create! name: 42
    assert_equal '42', issue.name
  end

  test 'integer_range' do
    issue = TestIssue.create! age_range: ['70', nil]
    assert_equal 70.., issue.age_range

    issue = TestIssue.find issue.id
    assert_equal 70.., issue.age_range
  end
end
