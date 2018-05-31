require 'test_helper'

class Superstore::Types::DateRangeTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal '2004-04-25', type.encode(Date.new(2004, 4, 25) .. Date.new(2004, 5, 15))
  end

  # test 'decode' do
  #   assert_nil type.decode('')
  #   assert_nil type.decode('nil')
  #   assert_nil type.decode('bad format')
  #   assert_equal Date.new(2004, 4, 25), type.decode('2004-04-25')
  #   assert_equal Date.new(2017, 5, 1), type.decode('2017-05-01T21:39:06.796897Z')
  # end
  #
  # test 'typecast' do
  #   assert_nil type.typecast(1000)
  #   assert_nil type.typecast(1000.0)
  #
  #   my_time = Time.current
  #   assert_equal my_time.to_date, type.typecast(my_time)
  # end
end
