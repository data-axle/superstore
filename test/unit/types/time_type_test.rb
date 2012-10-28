require 'test_helper'

class CassandraObject::Types::TimeTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal '2004-12-24T01:02:03.000000Z', coder.encode(Time.utc(2004, 12, 24, 1, 2, 3))
  end
end
