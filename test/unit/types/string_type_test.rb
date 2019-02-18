require 'test_helper'

class Superstore::Types::StringTypeTest < Superstore::Types::TestCase
  test 'serialize' do
    assert_equal 'abc', type.serialize('abc')
  end

  test 'serialize as utf' do
    assert_equal(
      '123'.force_encoding('UTF-8').encoding,
      type.serialize('123'.force_encoding('ASCII-8BIT')).encoding
    )
  end

  test 'serialize frozen as utf' do
    assert_equal(
      '123'.force_encoding('UTF-8').encoding,
      type.serialize('123'.force_encoding('ASCII-8BIT').freeze).encoding
    )
  end

  test 'cast_value' do
    assert_equal '123', type.cast_value(123)
    assert_equal '123', type.cast_value('123')
  end
end
