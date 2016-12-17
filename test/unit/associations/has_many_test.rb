require 'test_helper'

class Superstore::Associations::HasManyTest < Superstore::TestCase
  class TestObject < Issue
  end

  test 'has_many active_record association' do
    issue = TestObject.create!
    label = Label.create! name: 'important', issue_id: issue.id

    assert_equal [label], issue.labels
  end

  test 'create supports preloaded records' do
    issue = TestObject.create!
    issue.labels = Label.all

    issue.labels.create! name: 'blue'

    assert_equal 1, issue.labels.size
  end

  test 'has_many superstore association' do
    parent_issue = Issue.create!
    child_issue = Issue.create! parent_issue: parent_issue

    assert_equal [child_issue], parent_issue.children_issues
    assert_equal parent_issue.object_id, parent_issue.children_issues.first.parent_issue.object_id
  end
end
