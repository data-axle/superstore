require 'test_helper'

class Superstore::Types::DateRangeTypeTest < Superstore::Types::TestCase
  test 'serialize' do
    assert_equal ["2004-04-25", "2004-05-15"], type.serialize(Date.new(2004, 4, 25) .. Date.new(2004, 5, 15))
  end

  test 'deserialize' do
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.deserialize(["2004-04-25", "2004-05-15"])
    assert_nil type.deserialize(["2004-05-15", "2004-04-25"])

    # decode returns argument if already a Range
    range = Date.new(2019, 1, 1)..Date.new(2019, 2, 1)
    assert_equal range, type.deserialize(range)
  end

  test 'cast_value' do
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.cast_value(Date.new(2004, 4, 25)..Date.new(2004, 5, 15))
    assert_nil type.cast_value(Date.new(2004, 5, 15)..Date.new(2004, 4, 25))
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.cast_value([Date.new(2004, 4, 25), Date.new(2004, 5, 15)])
    assert_nil type.cast_value([Date.new(2004, 5, 15), Date.new(2004, 4, 25)])
    assert_equal Date.new(2004, 4, 25)..Date.new(2004, 5, 15), type.cast_value(["2004-04-25", "2004-05-15"])

    assert_nil type.cast_value(["2004-04-25", nil])
    assert_nil type.cast_value([nil, "2004-05-15"])
    assert_nil type.cast_value(["xx", "2004-05-15"])
  end
end
