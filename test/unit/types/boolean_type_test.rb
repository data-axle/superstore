require 'test_helper'

class Superstore::Types::BooleanTypeTest < Superstore::Types::TestCase
  test 'typecast' do
    assert_equal true, type.typecast('1')
    assert_equal true, type.typecast('true')
    assert_equal true, type.typecast('true')
    assert_equal false, type.typecast('0')
    assert_equal false, type.typecast(false)
    assert_nil type.typecast('')
  end
end
