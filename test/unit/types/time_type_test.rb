require 'test_helper'

class Superstore::Types::TimeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '2004-12-24T01:02:03.000000Z', coder.encode(Time.utc(2004, 12, 24, 1, 2, 3))
    assert_equal '2004-12-24T01:02:03.000000Z', coder.encode(DateTime.new(2004, 12, 24, 1, 2, 3))
    assert_raise ArgumentError do
      coder.encode 123
    end
  end

  test 'decode' do
    assert_nil coder.decode(nil)
    assert_nil coder.decode('bad format')
    assert_equal Time.utc(2004, 12, 24, 1, 2, 3), coder.decode('2004-12-24T01:02:03.000000Z')

    Time.use_zone 'Central Time (US & Canada)' do
      with_zone = coder.decode('2013-07-18 13:12:46 -0700')
      assert_equal Time.utc(2013, 07, 18, 20, 12, 46), with_zone
      assert_equal 'CDT', with_zone.zone
    end
  end
end
