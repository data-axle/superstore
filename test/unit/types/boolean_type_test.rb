require 'test_helper'

class Superstore::Types::BooleanTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '1', coder.encode(true)
    assert_equal '1', coder.encode('true')
    assert_equal '1', coder.encode('1')

    assert_equal '0', coder.encode(false)
    assert_equal '0', coder.encode('false')
    assert_equal '0', coder.encode('0')
    assert_equal '0', coder.encode('')

    assert_raise ArgumentError do
      coder.encode('wtf')
    end
  end

  test 'decode' do
    assert_equal true, coder.decode('1')
    assert_equal false, coder.decode('0')
    # assert_nil coder.decode(nil)
  end
end
