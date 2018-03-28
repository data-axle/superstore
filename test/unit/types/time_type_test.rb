require 'test_helper'

class Superstore::Types::TimeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '2004-12-24T01:02:03.000000Z', type.encode(Time.utc(2004, 12, 24, 1, 2, 3))
    assert_equal '2004-12-24T01:02:03.000000Z', type.encode(DateTime.new(2004, 12, 24, 1, 2, 3))
    assert_raise ArgumentError do
      type.encode 123
    end
  end

  test 'decode' do
    assert_nil type.decode(nil)
    assert_nil type.decode('bad format')
    assert_equal Time.utc(2004, 12, 24, 1, 2, 3), type.decode('2004-12-24T01:02:03.000000Z')
    assert_equal Time.utc(2004, 12, 24, 12, 13, 45), type.decode('2004-12-24 12:13:45 -0000')

    Time.use_zone 'Central Time (US & Canada)' do
      with_zone = type.decode('2013-07-18T13:12:46-07:00')
      assert_equal Time.utc(2013, 07, 18, 20, 12, 46), with_zone
      assert_equal 'CDT', with_zone.zone
    end
  end

  test 'typecast' do
    assert_nil type.typecast(1000)
    assert_nil type.typecast(1000.0)

    my_date = Date.new
    assert_equal my_date.to_time, type.typecast(my_date)
  end
end
