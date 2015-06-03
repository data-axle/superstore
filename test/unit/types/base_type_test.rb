require 'test_helper'

class Superstore::Types::BaseTypeTest < Superstore::Types::TestCase
  test 'default' do
    assert_equal nil, type.default
    assert_equal '5', Superstore::Types::BaseType.new(Issue, default: '5').default
    assert_equal 5.object_id, Superstore::Types::BaseType.new(Issue, default: 5).default.object_id
  end

  test 'encode' do
    assert_equal 'x', type.encode('x')
  end

  test 'decode' do
    assert_equal 'abc', type.decode('abc')
  end
end
