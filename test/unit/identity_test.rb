require 'test_helper'

class CassandraObject::IdentityTest < CassandraObject::TestCase
  test 'get id' do
    issue = Issue.create

    assert_equal issue.key.to_s, issue.id
  end

  test 'set id' do
    uuid = SimpleUUID::UUID.new.to_guid
    issue = Issue.create id: uuid

    assert_equal issue.key.to_s, uuid
  end

  test 'parse_key' do
    assert_kind_of(
      CassandraObject::Identity::UUIDKeyFactory::UUID,
      Issue.parse_key('bb4cbbbc-b7c7-11e0-9ca2-732604ff41fe')
    )
    
    assert_nil Issue.parse_key('fail')
  end
end