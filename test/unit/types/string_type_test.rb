require 'test_helper'

class CassandraObject::Types::StringTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal 'abc', coder.encode('abc')

    assert_raise ArgumentError do
      coder.encode(123)
    end
  end

  test 'wrap' do
    assert_equal(
      '123'.force_encoding('UTF-8').encoding,
      coder.wrap(nil, nil, '123'.force_encoding('ASCII-8BIT')).encoding
    )
  end

  test 'wrap when frozen' do
    assert_equal(
      '123'.force_encoding('UTF-8').encoding,
      coder.wrap(nil, nil, '123'.force_encoding('ASCII-8BIT').freeze).encoding
    )
  end

  test 'wrap when not a string' do
    assert_equal(
      "123",
      coder.wrap(nil, nil, 123)
    )
  end
end
