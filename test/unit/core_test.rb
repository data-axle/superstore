require 'test_helper'

class Superstore::CoreTest < Superstore::TestCase
  test 'initialize' do
    issue = Issue.new

    assert issue.new_record?
    assert !issue.destroyed?
  end

  test 'equality of new records' do
    assert_not_equal Issue.new, Issue.new
  end

  test 'equality' do
    first_issue = Issue.create
    second_issue = Issue.create

    assert_equal first_issue, first_issue
    assert_equal first_issue, Issue.find(first_issue.id)
    assert_not_equal first_issue, second_issue
  end

  test 'to_param' do
    issue = Issue.new
    assert_equal issue.id, issue.to_param
  end

  test 'hash' do
    issue = Issue.create
    issue2 = Issue.create
    refute_equal issue.hash, issue2.hash

    issue3 = Issue.new(id: issue.id)
    assert_equal issue.hash, issue3.hash

    user = User.new(id: issue.id)
    refute_equal issue.hash, user.hash
  end

  test 'inspect' do
    issue = Issue.create
    assert issue.inspect =~ /^#<Issue id: \"\w+\", description: \".+\", created_at: \".+\", updated_at: \".+\">$/
  end

  test 'inspect class' do
    expected = "Issue(widget_id: integer, id: string, description: string, title: string, parent_issue_id: string, comments: json, tags: array, created_at: time, updated_at: time)"
    assert_equal expected, Issue.inspect
  end
end
