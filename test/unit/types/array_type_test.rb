require 'test_helper'

class Superstore::Types::ArrayTypeTest < Superstore::Types::TestCase
  test 'encode' do
    assert_equal ['1', '2'].to_json, coder.encode(['1', '2'])

    assert_raise ArgumentError do
      coder.encode('wtf')
    end
  end

  test 'decode' do
    assert_equal ['1', '2'], coder.decode(['1', '2'].to_json)
    assert_equal nil, coder.decode(nil)
    assert_equal nil, coder.decode('')
  end

  test 'typecast' do
    assert_equal ['x', 'y'], coder.typecast(['x', 'y'].to_set)
  end
end
