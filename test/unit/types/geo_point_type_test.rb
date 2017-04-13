require 'test_helper'

class Superstore::Types::GeoPointTypeTest < Superstore::Types::TestCase
  test 'decode' do
    lat, lon = 47.604, -122.329
    seattle = {lat: lat, lon: lon}

    assert_equal seattle, type.decode("#{lat}, #{lon}")
    assert_equal seattle, type.decode("#{lat} #{lon}")
    assert_nil type.decode('invalid')
  end

  test 'typecast' do
    lat, lon = 47.604, -122.329
    seattle = {lat: lat, lon: lon}

    assert_equal seattle, type.typecast(lat: lat, lon: lon)
    assert_equal seattle, type.typecast({ "lat" => lat, "lon" => lon })
    assert_equal seattle, type.typecast([lat, lon])

    assert_equal({lat: 0.0, lon: 0.0}, type.typecast(lat: "cats", lon: "dogs"))

    assert_nil type.typecast([])
    assert_nil type.typecast('invalid')
  end
end
