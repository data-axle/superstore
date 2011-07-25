require 'test_helper'

class CassandraObject::IdentityTest < CassandraObject::TestCase
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