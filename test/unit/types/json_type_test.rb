require 'test_helper'

class Superstore::Types::JsonTypeTest < Superstore::Types::TestCase
  test 'typecast' do
    assert_equal({'enabled' => false}, type.typecast('enabled' => false))
    assert_equal({'born_at' => "2004-12-24T00:00:00.000Z"}, type.typecast('born_at' => Time.utc(2004, 12, 24)))
    assert_equal(["2004-12-24T00:00:00.000Z"], type.typecast([Time.utc(2004, 12, 24)]))
  end
end
