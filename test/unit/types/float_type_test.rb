require 'test_helper'

class Superstore::Types::FloatTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '5.01', coder.encode(5.01)

    assert_raise ArgumentError do
      coder.encode('x')
    end
  end

  test 'decode' do
    assert_equal 0.0, coder.decode('xyz')
    assert_equal 3.14, coder.decode('3.14')
    assert_equal 5, coder.decode('5')
  end
end
