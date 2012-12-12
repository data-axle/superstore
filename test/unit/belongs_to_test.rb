require 'test_helper'

class CassandraObject::BelongsToTest < CassandraObject::TestCase
  class TestObject < Issue
    string :issue_id
    belongs_to :issue

    string :widget_id
    belongs_to :widget, class_name: 'Issue'

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
