require 'test_helper'

class Superstore::Types::BooleanTypeTest < Superstore::Types::TestCase
  test 'cast_value' do
    assert_equal true, type.cast_value('1')
    assert_equal true, type.cast_value('true')
    assert_equal true, type.cast_value('true')
    assert_equal false, type.cast_value('0')
    assert_equal false, type.cast_value(false)
    assert_nil type.cast_value('')
  end
end
