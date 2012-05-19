require 'test_helper'

class CassandraObject::IdentityTest < CassandraObject::TestCase
  test 'primary_key' do
    assert_equal 'id', Issue.primary_key
  end

  test 'default _generate_key' do
    issue = Issue.new

    assert_not_nil Issue._generate_key(issue)
  end

  test 'custom key' do
    model = temp_object do
      key do
        "name:#{name}"
      end
      attr_accessor :name
    end
    record = model.new
    record.name = 'bar'

    assert_equal 'name:bar', model._generate_key(record)
  end
end