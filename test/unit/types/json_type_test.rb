require 'test_helper'

class CassandraObject::Types::JsonTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal({a: 'b'}.to_json, coder.encode(a: 'b'))
    assert_equal '-3', coder.encode(-3)
  end

  test 'decode' do
    assert_equal({'a' => 'b'}, coder.decode({'a' => 'b'}.to_json))
  end

  test 'delete marks dirty' do
    record = temp_object do
      string :name
      json :stuff

    end.new name: 'abcd', stuff: Hash[a: 1, b: 2]

    record.stuff.delete :b

    assert record.stuff_changed?
    assert_equal Hash[a: 1], record.stuff
  end


end
