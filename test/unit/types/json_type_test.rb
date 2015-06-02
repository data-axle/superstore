require 'test_helper'

class Superstore::Types::JsonTypeTest < Superstore::Types::TestCase
  if Superstore::Base.adapter.is_a?(Superstore::Adapters::CassandraAdapter)
    test 'encode' do
      assert_equal({a: 'b'}.to_json, coder.encode(a: 'b'))
      assert_equal '-3', coder.encode(-3)
    end

    test 'decode' do
      assert_equal({'a' => 'b'}, coder.decode({'a' => 'b'}.to_json))
    end

    test 'encode array' do
      assert_equal(['a', 'b'].to_json, coder.encode(['a', 'b']))
      assert_equal '-3', coder.encode(-3)
    end

    test 'decode array' do
      assert_equal(['a', 'b'], coder.decode(['a', 'b'].to_json))
    end
  end

  test 'typecast' do
    assert_equal({'enabled' => false}, coder.typecast('enabled' => false))
    assert_equal({'born_at' => "2004-12-24T00:00:00.000Z"}, coder.typecast('born_at' => Time.utc(2004, 12, 24)))
    assert_equal(["2004-12-24T00:00:00.000Z"], coder.typecast([Time.utc(2004, 12, 24)]))
  end
end
