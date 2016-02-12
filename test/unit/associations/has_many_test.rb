require 'test_helper'

class Superstore::Associations::HasManyTest < Superstore::TestCase
  class TestObject < Issue
  end

  test 'has_many' do
    issue = TestObject.create!
    label = Label.create! name: 'important', issue_id: issue.id

    assert_equal [label], issue.labels
  end

  test 'create supports preloaded records' do
    issue = TestObject.create!
    issue.labels = Label.all.to_a

    issue.labels.create! name: 'blue'

    assert_equal 1, issue.labels.size
  end
end
