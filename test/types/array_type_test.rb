require 'test_helper'

class CassandraObject::Types::ArrayTypeTest < CassandraObject::Types::TestCase
  test 'ignore_nil' do
    assert_equal false, coder.ignore_nil?
  end
  
  test 'encode' do
    assert_equal ['1', '2'].to_json, coder.encode(['1', '2'])
    
    assert_raise ArgumentError do
      coder.encode('wtf')
    end
  end

  test 'decode' do
    assert_equal ['1', '2'], coder.decode(['1', '2'].to_json)
  end

  class TestIssue < CassandraObject::Base
    self.column_family = 'Issue'
    array :favorite_colors
  end

  test 'wrap' do
    issue = TestIssue.new
    colors = []
    wrapper = coder.wrap(issue, 'favorite_colors', colors)

    assert_kind_of Array, wrapper
    
    assert !issue.changed?
    wrapper << 'red'
    assert issue.changed?
  end
end
