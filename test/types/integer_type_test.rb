require 'test_helper'

class CassandraObject::Types::IntegerTypeTest < CassandraObject::TestCase
  test 'encode' do
    assert_equal '3', CassandraObject::Types::IntegerType.encode(3)
    assert_equal '-3', CassandraObject::Types::IntegerType.encode(-3)

    assert_raise ArgumentError do
      CassandraObject::Types::BooleanType.encode('xx')
    end
  end

  test 'decode' do
    assert_nil CassandraObject::Types::IntegerType.decode('')
    assert_equal 3, CassandraObject::Types::IntegerType.decode('3')
    assert_equal -3, CassandraObject::Types::IntegerType.decode('-3')
  end
end