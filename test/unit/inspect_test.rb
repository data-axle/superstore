require 'test_helper'

class CassandraObject::InspectTest < CassandraObject::TestCase
  test 'attribute_for_inspect' do
    object = temp_object do
      string :long_string
      time :the_time
      integer :other
    end

    assert_equal "#{'x' * 51}...".inspect, object.new(long_string: 'x' * 100).attribute_for_inspect(:long_string)
    assert_equal "2012-02-14 12:01:02".inspect, object.new(the_time: Time.new(2012, 02, 14, 12, 01, 02)).attribute_for_inspect(:the_time)
    assert_equal "5", object.new(other: 5).attribute_for_inspect(:other)
  end

  test 'inspect' do
    object = temp_object do
      string :description
      integer :price
    end.new(description: "yeah buddy", price: 42)

    assert_match /id/, object.inspect
    assert_match /description/, object.inspect
  end
end