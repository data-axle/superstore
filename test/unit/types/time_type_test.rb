require 'test_helper'

class Superstore::Types::TimeTypeTest < Superstore::Types::TestCase
  test 'serialize' do
    assert_equal '2004-12-24T01:02:03.000000Z', type.serialize(Time.utc(2004, 12, 24, 1, 2, 3))
    assert_equal '2004-12-24T01:02:03.000000Z', type.serialize(DateTime.new(2004, 12, 24, 1, 2, 3))
    assert_raise ArgumentError do
      type.serialize 123
    end
  end

  test 'deserialize' do
    assert_nil type.deserialize(nil)
    assert_nil type.deserialize('bad format')
    assert_equal Time.utc(2004, 12, 24, 1, 2, 3), type.deserialize('2004-12-24T01:02:03.000000Z')
    assert_equal Time.utc(2004, 12, 24, 12, 13, 45), type.deserialize('2004-12-24 12:13:45 -0000')

    Time.use_zone 'Central Time (US & Canada)' do
      with_zone = type.deserialize('2013-07-18T13:12:46-07:00')
      assert_equal Time.utc(2013, 07, 18, 20, 12, 46), with_zone
      assert_equal 'CDT', with_zone.zone
    end
  end

  test 'cast_value' do
    assert_nil type.cast_value(1000)
    assert_nil type.cast_value(1000.0)

    my_date = Date.new
    assert_equal my_date.to_time, type.cast_value(my_date)
  end
end
