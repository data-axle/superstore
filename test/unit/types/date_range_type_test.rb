require 'test_helper'

class Superstore::Types::DateRangeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal ["2004-04-25", "2004-05-15"], type.encode(Date.new(2004, 4, 25) .. Date.new(2004, 5, 15))
  end

  test 'decode' do
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.decode(["2004-04-25", "2004-05-15"])
    assert_nil type.decode(["2004-05-15", "2004-04-25"])
  end

  test 'typecast' do
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.typecast(Date.new(2004, 4, 25)..Date.new(2004, 5, 15))
    assert_nil type.typecast(Date.new(2004, 5, 15)..Date.new(2004, 4, 25))
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.typecast([Date.new(2004, 4, 25), Date.new(2004, 5, 15)])
    assert_nil type.typecast([Date.new(2004, 5, 15), Date.new(2004, 4, 25)])
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.typecast(["2004-04-25", "2004-05-15"])

    assert_nil type.typecast(["2004-04-25", nil])
    assert_nil type.typecast([nil, "2004-05-15"])
    assert_nil type.typecast(["xx", "2004-05-15"])
  end
end
