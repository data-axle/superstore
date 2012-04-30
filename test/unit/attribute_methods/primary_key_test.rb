require 'test_helper'

class CassandraObject::AttributeMethods::PrimaryTest < CassandraObject::TestCase
  test 'get id' do
    issue = Issue.new

    assert_equal issue.key.to_s, issue.id
  end

  test 'set id' do
    uuid = SimpleUUID::UUID.new.to_guid
    issue = Issue.new id: uuid

    assert_equal issue.key.to_s, uuid
  end

  test 'attributes' do
    issue = Issue.new

    assert_not_nil issue.attributes['id']
  end
end