require 'test_helper'

class Superstore::Types::IntegerTypeTest < Superstore::Types::TestCase
  test 'typecast' do
    assert_nil type.typecast('my_int', '').value
    assert_nil type.typecast('my_int', 'abc').value
    assert_equal 3, type.typecast('my_int', 3).value
    assert_equal 3, type.typecast('my_int', '3').value
    assert_equal(-3, type.typecast('my_int', '-3').value)
    assert_equal 27, type.typecast('my_int', '027').value
    assert_equal 'my_int', type.typecast('my_int', 3).name

    assert type.typecast('my_int', 3).type.is_a? ActiveModel::Type::Integer
  end
end
