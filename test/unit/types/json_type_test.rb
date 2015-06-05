require 'test_helper'

class Superstore::Types::JsonTypeTest < Superstore::Types::TestCase
  if Superstore::Base.adapter.class.name == 'Superstore::Adapters::CassandraAdapter'
    test 'encode' do
      assert_equal({a: 'b'}.to_json, type.encode(a: 'b'))
      assert_equal '-3', type.encode(-3)
    end

    test 'decode' do
      assert_equal({'a' => 'b'}, type.decode({'a' => 'b'}.to_json))
    end

    test 'encode array' do
      assert_equal(['a', 'b'].to_json, type.encode(['a', 'b']))
      assert_equal '-3', type.encode(-3)
    end

    test 'decode array' do
      assert_equal(['a', 'b'], type.decode(['a', 'b'].to_json))
    end
  end

  test 'typecast' do
    assert_equal({'enabled' => false}, type.typecast('enabled' => false))
    assert_equal({'born_at' => "2004-12-24T00:00:00.000Z"}, type.typecast('born_at' => Time.utc(2004, 12, 24)))
    assert_equal(["2004-12-24T00:00:00.000Z"], type.typecast([Time.utc(2004, 12, 24)]))
  end
end
