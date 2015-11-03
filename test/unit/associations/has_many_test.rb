require 'test_helper'

class Superstore::Associations::HasManyTest < Superstore::TestCase
  class TestObject < Issue
  end

  test 'has_many' do
    issue = TestObject.create!
    label = Label.create! name: 'important', issue_id: issue.id

    assert_equal [label], issue.labels
  end
end
