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

  test 'array attribute' do
    issue = TestIssue.new favorite_colors: []
    
    assert_kind_of Array, issue.favorite_colors
    issue.favorite_colors << 'red'

    assert issue.changed?
    assert_equal({'favorite_colors' => [nil, ['red']]}, issue.changes)
  end

  test 'array uniques' do
    issue = TestIssue.create! favorite_colors: ['red', 'blue']

    issue.favorite_colors << 'red'
    assert_equal ['red', 'blue'], issue.favorite_colors
    assert !issue.changed?

    issue.favorite_colors << 'yellow'
    assert_equal ['red', 'blue', 'yellow'], issue.favorite_colors
    assert_equal({'favorite_colors' => [['red', 'blue'], ['red', 'blue', 'yellow']]}, issue.changes)
  end
end
