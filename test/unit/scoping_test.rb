require 'test_helper'

class Superstore::ScopingTest < Superstore::TestCase
  test "scope" do
    assert_kind_of Superstore::Scope, Issue.scope
  end
end
