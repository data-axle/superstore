require 'test_helper'

class Superstore::Types::ArrayTypeTest < Superstore::Types::TestCase
  test 'cast_value' do
    assert_equal ['x', 'y'], type.cast_value(['x', 'y'].to_set)
    assert_equal ['x'], type.cast_value('x')
    assert_nil type.cast_value('x')
  end
end
