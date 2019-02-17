require 'test_helper'

class Superstore::Types::FloatTypeTest < Superstore::Types::TestCase
  test 'cast_value' do
    assert_nil type.cast_value('xyz')
    assert_equal 1.1, type.cast_value('1.1')
    assert_equal 42.0, type.cast_value(42)
  end
end
