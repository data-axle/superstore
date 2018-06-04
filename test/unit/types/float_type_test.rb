require 'test_helper'

class Superstore::Types::FloatTypeTest < Superstore::Types::TestCase
  test 'typecast' do
    assert_nil type.typecast('xyz')
    assert_equal 1.1, type.typecast('1.1')
    assert_equal 42.0, type.typecast(42)
  end
end
