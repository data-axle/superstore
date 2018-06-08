require 'test_helper'

class Superstore::Types::IntegerTypeTest < Superstore::Types::TestCase
  test 'typecast' do
    assert_nil type.typecast('')
    assert_nil type.typecast('abc')
    assert_equal 3, type.typecast(3)
    assert_equal 3, type.typecast('3')
    assert_equal(-3, type.typecast('-3'))
    assert_equal 27, type.typecast('027')
  end
end
