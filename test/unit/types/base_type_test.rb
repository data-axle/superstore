require 'test_helper'

class Superstore::Types::BaseTypeTest < Superstore::Types::TestCase
  test 'default' do
    assert_equal nil, coder.default
    assert_equal '5', Superstore::Types::BaseType.new(default: '5').default
    assert_equal 5.object_id, Superstore::Types::BaseType.new(default: 5).default.object_id
  end

  test 'encode' do
    assert_equal '1', coder.encode(1)
    assert_equal '', coder.encode(nil)
    assert_equal '1', coder.encode('1')
  end

  test 'decode' do
    assert_equal 'abc', coder.decode('abc')
  end
end
