require 'test_helper'

class Superstore::Types::IntegerTypeTest < Superstore::Types::TestCase
  test 'decode' do
    assert_nil type.decode('')
    assert_equal(0, type.decode('abc'))
    assert_equal(3, type.decode('3'))
    assert_equal(-3, type.decode('-3'))
  end
end
