require 'test_helper'

class Superstore::CoreTest < Superstore::TestCase
  test 'initialize' do
    issue = Issue.new

    assert issue.new_record?
    assert !issue.destroyed?
  end

  test 'initialize yields self' do
    issue = Issue.new { |i| i.description = 'bar' }
    assert_equal 'bar', issue.description
  end

  test 'dup' do
    issue = Issue.create description: 'foo', comments: {"foo" => "bar"}

    dup_issue = issue.dup

    assert dup_issue.new_record?
    refute_equal issue.id, dup_issue.id
    assert_nil dup_issue.created_at
    assert_nil dup_issue.updated_at
    assert_equal issue.description, dup_issue.description
    refute_equal issue.description.object_id, dup_issue.description.object_id
    refute_equal issue.comments['foo'].object_id, dup_issue.comments['foo'].object_id
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
    assert issue.inspect =~ /^#<Issue id: \"\w+\", created_at: \".+\", updated_at: \".+\", description: \".+\">$/
  end
end
