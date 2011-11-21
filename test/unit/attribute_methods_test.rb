require 'test_helper'

class CassandraObject::AttributeMethodsTest < CassandraObject::TestCase
  test 'read and write attributes' do
    issue = Issue.new
    assert_nil issue.read_attribute(:description)

    issue.write_attribute(:description, nil)
    assert_nil issue.read_attribute(:description)

    issue.write_attribute(:description, 'foo')
    assert_equal 'foo', issue.read_attribute(:description)
  end

  test 'hash accessor aliases' do
    issue = Issue.new

    issue[:description] = 'bar'

    assert_equal 'bar', issue[:description]
  end

  # test 'attribute_exists' do
  #   assert !Issue.new.attribute_exists?(:description)
  #   assert Issue.new(description: nil).attribute_exists?(:description)
  #   assert Issue.new(description: false).attribute_exists?(:description)
  #   assert Issue.new(description: 'hey').attribute_exists?(:description)
  # end

  test 'attributes setter' do
    issue = Issue.new

    issue.attributes = {
      description: 'foo'
    }

    assert_equal 'foo', issue.description
  end
end
