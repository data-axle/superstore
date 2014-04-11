require 'test_helper'

class Superstore::Types::IntegerTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '3', coder.encode(3)
    assert_equal '-3', coder.encode(-3)

    assert_raise ArgumentError do
      coder.encode('xx')
    end
  end

  test 'decode' do
    assert_nil coder.decode('')
    assert_equal 0, coder.decode('abc')
    assert_equal 3, coder.decode('3')
    assert_equal -3, coder.decode('-3')
  end
end
