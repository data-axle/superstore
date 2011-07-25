require 'test_helper'

class CassandraObject::Types::SetTypeTest < CassandraObject::TestCase
  test 'encode' do
    assert_equal ['1', '2'].to_json, CassandraObject::Types::SetType.encode(['1', '2'].to_set)
    assert_equal ['1', '2'].to_json, CassandraObject::Types::SetType.encode(['1', '2', '2'])

    assert_raise ArgumentError do
      CassandraObject::Types::SetType.encode('wtf')
    end
  end
  
  test 'decode' do
    assert_equal ['1', '2'], CassandraObject::Types::SetType.decode(['1', '2'].to_set)
    assert_equal ['1', '2'], CassandraObject::Types::SetType.decode(['1', '2'].to_json)
  end
end