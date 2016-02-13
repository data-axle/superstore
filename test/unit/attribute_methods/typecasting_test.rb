require 'test_helper'

class Superstore::AttributeMethods::TypecastingTest < Superstore::TestCase
  class TestIssue < Superstore::Base
    self.table_name = 'issues'

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

  test 'typecast_attribute' do
    assert_equal 1, TestIssue.typecast_attribute('price', 1)
    assert_equal 1, TestIssue.typecast_attribute(:price, 1)

    assert_raise NoMethodError do
      TestIssue.typecast_attribute('wtf', 1)
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

  test 'multiple attributes definition' do
    class MultipleAttributesIssue < Superstore::Base
      self.table_name = 'issues'
    end

    assert_nothing_raised {
      MultipleAttributesIssue.string :hello, :greetings, :bye
    }
    issue = MultipleAttributesIssue.new :hello => 'hey', :greetings => 'how r u', :bye => 'see ya'

    assert_equal 'how r u', issue.greetings
  end

  test 'multiple attributes with options' do
    class MultipleAttributesIssue < Superstore::Base
      self.table_name = 'issues'
    end

    MultipleAttributesIssue.expects(:attribute).with(:hello, { :unique => :true, :type => :string })
    MultipleAttributesIssue.expects(:attribute).with(:world, { :unique => :true, :type => :string })

    class MultipleAttributesIssue < Superstore::Base
      string :hello, :world, :unique => :true
    end
  end
end
