require 'test_helper'

class Superstore::Types::FloatTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '5.01', type.encode(5.01)

    assert_raise ArgumentError do
      type.encode('x')
    end
  end

  test 'decode' do
    assert_equal 0.0, type.decode('xyz')
    assert_equal 3.14, type.decode('3.14')
    assert_equal 5, type.decode('5')
  end
end
