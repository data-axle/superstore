require 'test_helper'

class Superstore::Types::IntegerRangeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal [4, 5], type.encode(4..5)
    assert_equal [4, nil], type.encode(4..Float::INFINITY)
    assert_equal [nil, 5], type.encode(-Float::INFINITY..5)
  end

  test 'decode' do
    assert_equal 4..5, type.decode([4, 5])
    assert_equal 4..Float::INFINITY, type.decode([4, nil])
    assert_equal -Float::INFINITY..5, type.decode([nil, 5])
  end

  test 'typecast' do
    assert_equal 1..5, type.typecast(1..5)
    assert_equal 1..5, type.typecast([1, 5])
    assert_equal 1..Float::INFINITY, type.typecast([1, nil])
    assert_equal -Float::INFINITY..2, type.typecast([nil, 2])
  end
end
