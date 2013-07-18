require 'test_helper'

class CassandraObject::Types::TimeTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal '2004-12-24T01:02:03.000000Z', coder.encode(Time.utc(2004, 12, 24, 1, 2, 3))
  end

  test 'decode' do
    assert_nil coder.decode(nil)
    assert_nil coder.decode('bad format')
    assert_equal Time.utc(2004, 12, 24, 1, 2, 3), coder.decode('2004-12-24T01:02:03.000000Z')
    assert_equal Time.utc(2013, 07, 18, 20, 12, 46), coder.decode('2013-07-18 13:12:46 -0700')
  end
end
