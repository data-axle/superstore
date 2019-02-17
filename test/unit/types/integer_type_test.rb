require 'test_helper'

class Superstore::Types::IntegerTypeTest < Superstore::Types::TestCase
  test 'cast_value' do
    assert_nil type.cast_value('')
    assert_nil type.cast_value('abc')
    assert_equal 3, type.cast_value(3)
    assert_equal 3, type.cast_value('3')
    assert_equal(-3, type.cast_value('-3'))
    assert_equal 27, type.cast_value('027')
  end
end
