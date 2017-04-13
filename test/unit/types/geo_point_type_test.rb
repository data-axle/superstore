require 'test_helper'

class Superstore::Types::GeoPointTypeTest < Superstore::Types::TestCase
  test "typecase" do
    lat, lon = 47.604, -122.329
    seattle = {lat: lat, lon: lon}
    assert_equal seattle, formatter.standardize(definition, {lat: lat, lon: lon})
    assert_equal seattle, formatter.standardize(definition, { "lat" => lat, "lon" => lon })
    assert_equal seattle, formatter.standardize(definition, [lat, lon])

    assert_equal({ lat: 0.0, lon: 0.0 }, formatter.standardize(definition, { lat: "cats", lon: "dogs" }))
    assert_equal({ lat: nil, lon: nil }, formatter.standardize(definition, []))

    assert_equal seattle, formatter.standardize(definition, "#{lat}, #{lon}")
    assert_equal seattle, formatter.standardize(definition, "#{lat} #{lon}")
    assert_equal :invalid, formatter.standardize(definition, :invalid)
  end
end
