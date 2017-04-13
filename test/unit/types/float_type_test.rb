require 'test_helper'

class Superstore::Types::FloatTypeTest < Superstore::Types::TestCase
  test 'decode' do
    assert_equal 0.0, type.decode('xyz')
    assert_equal 3.14, type.decode('3.14')
    assert_equal 5, type.decode('5')
  end

  test 'typecast' do
    assert_equal 1.1, type.typecast('1.1')
    assert_equal 42.0, type.typecast(42)
  end
end
