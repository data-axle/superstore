require 'test_helper'

class Superstore::Types::IntegerRangeTypeTest < Superstore::Types::TestCase
  test 'serialize' do
    assert_equal [4, 5], type.serialize(4..5)
    assert_equal [4, nil], type.serialize(4..)
    assert_equal [nil, 5], type.serialize(-Float::INFINITY..5)
    assert_equal [nil, nil], type.serialize(-Float::INFINITY..)
  end

  test 'deserialize' do
    assert_equal 4..5, type.deserialize([4, 5])
    assert_nil type.deserialize([5, 4])
    assert_equal 4.., type.deserialize([4, nil])
    assert_equal (-Float::INFINITY..5), type.deserialize([nil, 5])
    assert_equal (-Float::INFINITY..), type.deserialize([nil, nil])
  end

  test 'cast_value' do
    assert_equal 1..5, type.cast_value(1..5)
    assert_nil type.cast_value(5..1)
    assert_equal 1..5, type.cast_value([1, 5])
    assert_nil type.cast_value([5, 1])
    assert_equal 1.., type.cast_value([1, nil])
    assert_equal (-Float::INFINITY..2), type.cast_value([nil, 2])
    assert_equal (-Float::INFINITY..), type.cast_value([nil, nil])
  end
end
