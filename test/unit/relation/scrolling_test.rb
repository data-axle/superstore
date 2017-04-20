require 'test_helper'

class Superstore::ScrollingTest < Superstore::TestCase
  ActiveRecord::Relation.class_eval do
    include Superstore::Relation::Scrolling
  end
  
  test 'scroll_each' do
    Issue.create
    Issue.create

    issues = []
    Issue.all.scroll_each do |issue|
      issues << issue
    end

    assert_equal Issue.all.to_set, issues.to_set
  end

  test 'scroll_in_batches' do
    Issue.create
    Issue.create
    Issue.create

    issue_batches = []
    Issue.all.scroll_in_batches(batch_size: 2) do |issues|
      issue_batches << issues
    end

    assert_equal 2, issue_batches.size
    assert issue_batches.any? { |issues| issues.size == 2 }
    assert issue_batches.any? { |issues| issues.size == 1 }
  end
end
