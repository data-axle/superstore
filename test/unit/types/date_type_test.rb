require 'test_helper'

class Superstore::Types::DateTypeTest < Superstore::Types::TestCase
  test 'serialize' do
    assert_equal '2004-04-25', type.serialize(Date.new(2004, 4, 25))
  end

  test 'deserialize' do
    assert_equal Date.new(2004, 4, 25), type.deserialize('2004-04-25')
  end

  test 'cast_value' do
    assert_nil type.cast_value(1000)
    assert_nil type.cast_value(1000.0)
    assert_nil type.cast_value('')
    assert_nil type.cast_value('nil')
    assert_nil type.cast_value('bad format')
    assert_equal Date.new(2004, 4, 25), type.cast_value('2004-04-25')
    assert_equal Date.new(2017, 5, 1), type.cast_value('2017-05-01T21:39:06.796897Z')

    my_time = Time.current
    assert_equal my_time.to_date, type.cast_value(my_time)
  end
end
