require 'test_helper'

class Superstore::BelongsToTest < Superstore::TestCase
  class TestObject < Issue
    string :issue_id
    belongs_to :issue

    string :widget_id
    belongs_to :widget, class_name: 'Issue'

    string :other_id
    belongs_to :other_issue, class_name: 'Issue', foreign_key: :other_id

    string :user_id
    belongs_to :user, primary_key: :special_id

    string :target_id
    string :target_type
    belongs_to :target, polymorphic: true
  end

  test 'belongs_to' do
    issue = Issue.create

    record = TestObject.create(issue: issue)

    assert_equal issue, record.issue
    assert_equal issue.id, record.issue_id

    record = TestObject.find(record.id)
    assert_equal issue, record.issue
  end

  test 'belongs_to with class_name' do
    issue = Issue.create

    record = TestObject.create(widget: issue)

    assert_equal issue, record.widget
    assert_equal issue.id, record.widget_id

    record = TestObject.find(record.id)
    assert_equal issue, record.widget
  end

  test 'belongs_to with foreign_key' do
    issue = Issue.create

    record = TestObject.create(other_issue: issue)

    assert_equal issue, record.other_issue
    assert_equal issue.id, record.other_id

    record = TestObject.find(record.id)
    assert_equal issue, record.other_issue
  end

  test 'belongs_to with primary_key' do
    special_id = 'special_id'
    user = User.create! special_id: special_id
    record = TestObject.create user: user

    assert_equal user, record.user
    assert_equal special_id, record.user_id

    record = TestObject.find(record.id)
    assert_equal user, record.user
  end

  test 'belongs_to with polymorphic' do
    issue = Issue.create

    record = TestObject.create(target: issue)

    assert_equal issue, record.target
    assert_equal issue.id, record.target_id
    assert_equal 'Issue', record.target_type

    record = TestObject.find(record.id)
    assert_equal issue, record.target
  end

  test 'belongs_to clear cache after reload' do
    issue = Issue.create
    record = TestObject.create(issue: issue)
    issue.destroy

    assert_not_nil record.issue
    assert_nil TestObject.find(record.id).issue
    assert_nil record.reload.issue
  end
end
