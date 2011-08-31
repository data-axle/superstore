require 'test_helper'

class CassandraObject::IdentityTest < CassandraObject::TestCase
  test 'id' do
    issue = Issue.create

    assert_equal issue.key.to_s, issue.id
  end

  test 'equality of new records' do
    assert_not_equal Issue.new, Issue.new
  end

  test 'equality' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert_equal first_issue, first_issue
    assert_not_equal first_issue, second_issue
  end

  test 'parse_key' do
    assert_kind_of(
      CassandraObject::Identity::UUIDKeyFactory::UUID,
      Issue.parse_key('bb4cbbbc-b7c7-11e0-9ca2-732604ff41fe')
    )
    
    assert_nil Issue.parse_key('fail')
  end
end