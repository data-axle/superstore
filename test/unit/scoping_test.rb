require 'test_helper'

class CassandraObject::ScopingTest < CassandraObject::TestCase
  test "scope" do
    assert_kind_of CassandraObject::Scope, Issue.scope
  end
end
