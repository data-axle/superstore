require 'test_helper'

class CassandraObject::Types::SetTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal ['1', '2'].to_json, coder.encode(['1', '2'].to_set)
    assert_equal ['1', '2'].to_json, coder.encode(['1', '2', '2'])

    assert_raise ArgumentError do
      coder.encode('wtf')
    end
  end
  
  test 'decode' do
    assert_equal ['1', '2'], coder.decode(['1', '2'].to_set)
    assert_equal ['1', '2'], coder.decode(['1', '2'].to_json)
  end
end