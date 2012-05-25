require 'test_helper'

class CassandraObject::AttributeMethods::PrimaryKeyTest < CassandraObject::TestCase
  test 'get id' do
    model = temp_object do
      key do
        "foo"
      end
    end
    record = model.new

    assert_equal 'foo', record.id
  end

  test 'set id' do
    issue = Issue.new id: 'foo'

    assert_equal 'foo', issue.id
  end

  test 'attributes' do
    issue = Issue.new

    assert_not_nil issue.attributes['id']
  end
end