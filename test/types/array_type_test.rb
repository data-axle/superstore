require 'test_helper'

class CassandraObject::Types::ArrayTypeTest < CassandraObject::TestCase
  test 'encode' do
    assert_equal ['1', '2'].to_json, CassandraObject::Types::ArrayType.encode(['1', '2'])
    
    assert_raise ArgumentError do
      CassandraObject::Types::ArrayType.encode('wtf')
    end
  end

  test 'decode' do
    assert_equal ['1', '2'], CassandraObject::Types::ArrayType.decode(['1', '2'].to_json)
  end
end