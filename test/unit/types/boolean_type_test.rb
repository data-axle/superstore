require 'test_helper'

class Superstore::Types::BooleanTypeTest < Superstore::Types::TestCase
  if Superstore::Base.adapter.class.name == 'Superstore::Adapters::CassandraAdapter'
    test 'encode' do
      assert_equal '1', type.encode(true)
      assert_equal '1', type.encode('true')
      assert_equal '1', type.encode('1')

      assert_equal '0', type.encode(false)
      assert_equal '0', type.encode('false')
      assert_equal '0', type.encode('0')
      assert_equal '0', type.encode('')

      assert_raise ArgumentError do
        type.encode('wtf')
      end
    end
  end

  test 'decode' do
    assert_equal true, type.decode('1')
    assert_equal false, type.decode('0')
    # assert_nil type.decode(nil)
  end
end
