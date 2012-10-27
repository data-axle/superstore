require 'test_helper'

class CassandraObject::TimestampsTest < CassandraObject::TestCase
  test 'timestamps set on create' do
    issue = Issue.create

    assert_in_delta Time.now.to_i, issue.created_at.to_i, 3
    assert_in_delta Time.now.to_i, issue.updated_at.to_i, 3
  end

  test 'updated_at set on change' do
    issue = Issue.create

    issue.updated_at = nil
    issue.description = 'lol'
    issue.save

    assert_in_delta Time.now.to_i, issue.updated_at.to_i, 3
  end

  test 'created_at sets only if nil' do
    time = 5.days.ago
    issue = Issue.create created_at: time

    assert_equal time, issue.created_at
  end
end
