require 'test_helper'

class Superstore::Types::ArrayTypeTest < Superstore::Types::TestCase
  test 'typecast' do
    assert_equal ['x', 'y'], type.typecast(['x', 'y'].to_set)
    assert_nil type.typecast('x')
  end
end
