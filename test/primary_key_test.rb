require 'test_helper'

class CassandraObject::PrimaryKeyTest < CassandraObject::TestCase
  test 'id' do
    issue = Issue.create

    assert_equal issue.key.to_s, issue.id
  end
end