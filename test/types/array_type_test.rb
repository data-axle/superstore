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
    key :uuid
    self.column_family = 'Issues'
    array :favorite_colors, unique: true
  end

  test 'wrap' do
    issue = TestIssue.create favorite_colors: []
    assert !issue.changed?
    assert_kind_of Array, issue.favorite_colors

    issue.favorite_colors << 'red'
    assert issue.changed?
    assert_equal({'favorite_colors' => [[], ['red']]}, issue.changes)
  end

  test 'unique array' do
    issue = TestIssue.create favorite_colors: ['blue', 'red']

    issue.favorite_colors = ['red', 'red', 'blue']
    assert !issue.changed?

    issue.favorite_colors = ['red', 'green']
    assert issue.changed?
  end
end
