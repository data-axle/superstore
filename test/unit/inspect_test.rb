require 'test_helper'

class CassandraObject::InspectTest < CassandraObject::TestCase
  test 'attribute_for_inspect' do
    object = temp_object do
      string :long_string
      time :the_time
      integer :other
    end

    assert_equal "#{'x' * 51}...".inspect, object.new.attribute_for_inspect('x' * 100)
    assert_equal "2012-02-14 12:01:02".inspect, object.new.attribute_for_inspect(Time.new(2012, 02, 14, 12, 01, 02))
    assert_equal "\"foo\"", object.new.attribute_for_inspect('foo')
  end

  test 'inspect' do
    object = temp_object do
      string :description
      integer :price
    end.new(description: "yeah buddy", price: nil)

    assert_match /id/, object.inspect
    assert_match /description/, object.inspect
    assert_no_match /price/, object.inspect
  end
end
