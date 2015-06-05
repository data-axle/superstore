require 'test_helper'

class Superstore::Types::ArrayTypeTest < Superstore::Types::TestCase
  if Superstore::Base.adapter.class.name == 'Superstore::Adapters::CassandraAdapter'
    test 'encode' do
      assert_equal ['1', '2'].to_json, type.encode(['1', '2'])

      assert_raise ArgumentError do
        type.encode('wtf')
      end
    end

    test 'decode' do
      assert_equal ['1', '2'], type.decode(['1', '2'].to_json)
      assert_equal nil, type.decode(nil)
      assert_equal nil, type.decode('')
    end
  end

  test 'typecast' do
    assert_equal ['x', 'y'], type.typecast(['x', 'y'].to_set)
  end
end
