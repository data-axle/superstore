require 'test_helper'

class CassandraObject::Types::BaseTypeTest < CassandraObject::Types::TestCase
  test 'ignore_nil' do
    assert_equal true, coder.ignore_nil?
  end

  test 'encode' do
    assert_equal '1', coder.encode(1)
    assert_equal '', coder.encode(nil)
    assert_equal '1', coder.encode('1')
  end

  test 'decode' do
    assert_equal 'abc', coder.decode('abc')
  end

  test 'wrap' do
    object = Object.new
    assert_equal object, coder.wrap(nil, nil, object)
  end
end