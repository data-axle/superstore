require 'test_helper'

class Superstore::CachingTest < Superstore::TestCase
  class ::OtherClass < Superstore::Base
    self.table_name = 'issues'
  end

  test 'for a new record' do
    issue = Issue.new
    other_class = OtherClass.new
    assert_equal "issues/new", issue.cache_key
    assert_equal "other_classes/new", other_class.cache_key
  end

  test 'for a persisted record' do
    updated_at = Time.now
    issue = Issue.create!(id: 1, updated_at: updated_at)

    assert_equal "issues/1-#{updated_at.utc.to_s(:nsec)}", issue.cache_key
  end
end
