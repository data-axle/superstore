require 'test_helper'

class Superstore::Types::JsonTypeTest < Superstore::Types::TestCase
  test 'serializes empty array to nil' do
    comments = { 'foo' => 'bar' }
    issue1   = Issue.new(comments:)
    issue2   = Issue.new(comments: [])
    issue3   = Issue.new(comments: {})

    assert_equal comments, issue1.comments
    assert_equal [], issue2.comments
    assert_equal({}, issue3.comments)

    [issue1, issue2].each(&:save!).each(&:reload)

    assert_equal comments, issue1.comments
    assert_nil issue2.comments
    assert_equal({}, issue3.comments)
  end
end
