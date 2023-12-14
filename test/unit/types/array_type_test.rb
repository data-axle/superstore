require 'test_helper'

class Superstore::Types::ArrayTypeTest < Superstore::Types::TestCase
  test 'cast_value' do
    assert_equal ['x', 'y'], type.cast_value(['x', 'y'].to_set)
    assert_equal ['x'], type.cast_value('x')
    assert_equal [], type.cast_value(nil)
  end

  test 'persistence' do
    tags   = %w(foo bar)
    issue1 = Issue.new(tags:)
    issue2 = Issue.new(tags: [])

    assert_equal tags, issue1.tags
    assert_equal [], issue2.tags

    [issue1, issue2].each(&:save!).each(&:reload)

    assert_equal tags, issue1.tags
    assert_nil issue2.tags
  end
end
