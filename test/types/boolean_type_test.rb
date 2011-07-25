require 'test_helper'

class CassandraObject::Types::BooleanTypeTest < CassandraObject::TestCase
  test 'encode' do
    assert_equal '1', CassandraObject::Types::BooleanType.encode(true)
    assert_equal '1', CassandraObject::Types::BooleanType.encode('true')
    assert_equal '1', CassandraObject::Types::BooleanType.encode('1')

    assert_equal '0', CassandraObject::Types::BooleanType.encode(false)
    assert_equal '0', CassandraObject::Types::BooleanType.encode('false')
    assert_equal '0', CassandraObject::Types::BooleanType.encode('0')
    assert_equal '0', CassandraObject::Types::BooleanType.encode('')

    assert_raise ArgumentError do
      CassandraObject::Types::BooleanType.encode('wtf')
    end
  end

  test 'decode' do
    assert_equal true, CassandraObject::Types::BooleanType.decode('1')
    assert_equal false, CassandraObject::Types::BooleanType.decode('0')
  end
end
