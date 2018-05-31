require 'test_helper'

class Superstore::Types::IntegerRangeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal [4, 5], type.encode(4..5)
    assert_equal [4, nil], type.encode(4..Float::INFINITY)
    assert_equal [nil, 5], type.encode(-Float::INFINITY..5)
  end

  # test 'decode' do
  #   assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.decode(["2004-04-25", "2004-05-15"])
  # end
  #
  # test 'typecast' do
  #   assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.typecast(Date.new(2004, 4, 25)..Date.new(2004, 5, 15))
  #   assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.typecast([Date.new(2004, 4, 25), Date.new(2004, 5, 15)])
  #   assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.typecast(["2004-04-25", "2004-05-15"])
  # end
end
