require 'test_helper'

class Superstore::Types::BaseTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal 'x', type.encode('x')
  end

  test 'decode' do
    assert_equal 'abc', type.decode('abc')
  end
end
