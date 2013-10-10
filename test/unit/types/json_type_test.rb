require 'test_helper'

class CassandraObject::Types::JsonTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal({a: 'b'}.to_json, coder.encode(a: 'b'))
    assert_equal '-3', coder.encode(-3)
  end

  test 'decode' do
    assert_equal({'a' => 'b'}, coder.decode({'a' => 'b'}.to_json))
  end

  test 'setting marks dirty' do
    record = temp_object do
      string :name
      json :stuff

    end.new name: 'abcd', stuff: Hash[a: 1, b: 2]

    record.save!
    assert !record.stuff_changed?

    record.stuff[:c] = 3

    assert record.stuff_changed?
    assert_equal Hash[a: 1, b: 2, c: 3], record.stuff
  end

  test 'hash change marks dirty' do
    record = temp_object do
      string :name
      json :stuff

    end.new name: 'abcd', stuff: Hash[a: 1, b: 2, v: {}]

    record.save!
    assert !record.stuff_changed?

    record.stuff[:v][:data] = 69
    record.stuff[:v] = record.stuff[:v]

    assert record.stuff_changed?
    assert_equal Hash[a: 1, b: 2, v: Hash[data: 69]], record.stuff
  end

  test 'hash no change does not dirty' do
    record = temp_object do
      string :name
      json :stuff

    end.new name: 'abcd', stuff: Hash[a: 1, b: 2, v: {data: 69}]

    record.save!
    assert !record.stuff_changed?

    record.stuff[:v][:data] = 69
    record.stuff[:v] = record.stuff[:v]

    assert !record.stuff_changed?
    assert_equal Hash[a: 1, b: 2, v: Hash[data: 69]], record.stuff
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
