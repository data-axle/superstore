require 'test_helper'

class Superstore::Types::DateTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '2004-04-25', type.encode(Date.new(2004, 4, 25))
  end

  test 'decode' do
    assert_equal Date.new(2004, 4, 25), type.decode('2004-04-25')
  end

  test 'decoding a blank dates' do
    assert_nil type.decode('')
  end
end
