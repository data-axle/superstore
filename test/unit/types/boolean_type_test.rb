require 'test_helper'

class Superstore::Types::BooleanTypeTest < Superstore::Types::TestCase
  test 'decode' do
    assert_equal true, type.decode('1')
    assert_equal false, type.decode('0')
    # assert_nil type.decode(nil)
  end
end
