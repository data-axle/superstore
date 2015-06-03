require 'test_helper'

class Superstore::Types::StringTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal 'abc', type.encode('abc')

    assert_raise ArgumentError do
      type.encode(123)
    end
  end

  test 'encode as utf' do
    assert_equal(
      '123'.force_encoding('UTF-8').encoding,
      type.encode('123'.force_encoding('ASCII-8BIT')).encoding
    )
  end

  test 'encode frozen as utf' do
    assert_equal(
      '123'.force_encoding('UTF-8').encoding,
      type.encode('123'.force_encoding('ASCII-8BIT').freeze).encoding
    )
  end

  test 'typecast' do
    assert_equal '123', type.typecast(123)
    assert_equal '123', type.typecast('123')
  end
end
