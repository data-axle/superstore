require 'test_helper'

class Superstore::Types::IntegerRangeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal [4, 5], type.encode(4..5)
    assert_equal [4, 5], type.encode(5..4)
    assert_equal [4, nil], type.encode(4..Float::INFINITY)
    assert_equal [nil, 5], type.encode(-Float::INFINITY..5)
    assert_equal [nil, nil], type.encode(-Float::INFINITY..Float::INFINITY)
  end

  test 'decode' do
    assert_equal 4..5, type.decode([4, 5])
    assert_equal 4..Float::INFINITY, type.decode([4, nil])
    assert_equal (-Float::INFINITY..5), type.decode([nil, 5])
    assert_equal (-Float::INFINITY..Float::INFINITY), type.decode([nil, nil])
  end

  test 'typecast' do
    assert_equal 1..5, type.typecast(1..5)
    assert_equal 1..5, type.typecast(5..1)
    assert_equal 1..5, type.typecast([1, 5])
    assert_equal 1..Float::INFINITY, type.typecast([1, nil])
    assert_equal (-Float::INFINITY..2), type.typecast([nil, 2])
    assert_equal (-Float::INFINITY..Float::INFINITY), type.typecast([nil, nil])
  end
end
