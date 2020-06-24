require 'test_helper'

class Superstore::Types::GeoPointTypeTest < Superstore::Types::TestCase
  test 'deserialize' do
    lat, lon = 47.604, -122.329
    seattle = {lat: lat, lon: lon}

    assert_equal seattle, type.deserialize('lat' => lat, 'lon' => lon)
  end

  test 'cast_value' do
    lat, lon = 47.604, -122.329
    seattle = {lat: lat, lon: lon}

    assert_equal seattle, type.cast_value(lat: lat, lon: lon)
    assert_equal seattle, type.cast_value({ "lat" => lat, "lon" => lon })
    assert_equal seattle, type.cast_value([lat, lon])

    assert_equal({lat: 0.0, lon: 0.0}, type.cast_value(lat: "cats", lon: "dogs"))

    assert_nil type.cast_value([])
    assert_nil type.cast_value('invalid')
  end

  test 'type' do
    assert_equal 'geo_point', type.type
  end
end
