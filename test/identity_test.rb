require 'test_helper'

class CassandraObject::IdentityTest < CassandraObject::TestCase
  test 'parse_key' do
    # p "Issue.parse_key('bb4cbbbc-b7c7-11e0-9ca2-732604ff41fe') = #{Issue.parse_key('bb4cbbbc-b7c7-11e0-9ca2-732604ff41fe').class}"
    assert_kind_of(
      CassandraObject::Identity::UUIDKeyFactory::UUID,
      Issue.parse_key('bb4cbbbc-b7c7-11e0-9ca2-732604ff41fe')
    )
    
    assert_nil Issue.parse_key('fail')
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
end