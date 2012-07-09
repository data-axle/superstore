require 'test_helper'

class CassandraObject::Types::ArrayTypeTest < CassandraObject::Types::TestCase
  test 'encode' do
    assert_equal ['1', '2'].to_json, coder.encode(['1', '2'])
    
    assert_raise ArgumentError do
      coder.encode('wtf')
    end
  end

  test 'decode' do
    assert_equal ['1', '2'], coder.decode(['1', '2'].to_json)
    assert_equal [], coder.decode(nil)
    assert_equal [], coder.decode('')
  end

  class TestIssue < CassandraObject::Base
    self.column_family = 'Issues'
    array :favorite_colors, unique: true
  end

  test 'default' do
    assert_equal [], TestIssue.new.favorite_colors
  end

  test 'append marks dirty' do
    issue = TestIssue.create favorite_colors: []
    assert !issue.changed?

    issue.favorite_colors << 'red'
    assert issue.changed?
    assert_equal({'favorite_colors' => [[], ['red']]}, issue.changes)
  end

  test 'delete marks dirty' do
    issue = TestIssue.create favorite_colors: ['red']
    assert !issue.changed?

    issue.favorite_colors.delete('red')
    assert issue.changed?
    assert_equal({'favorite_colors' => [['red'], []]}, issue.changes)
  end

  test 'unique array removes blank' do
    issue = TestIssue.create favorite_colors: ['blue', 'red', '', nil]
    assert_equal ['blue', 'red'], issue.favorite_colors
  end

  test 'unique array uniquifies' do
    issue = TestIssue.create favorite_colors: ['blue', 'red']
    
    issue.favorite_colors = ['red', 'red', 'blue']
    assert !issue.changed?
    
    issue.favorite_colors = ['red', 'green']
    assert issue.changed?
  end

  test 'unique array rescues argument error' do
    issue = TestIssue.create favorite_colors: [1, 'red']

    assert_equal [1, 'red'], issue.favorite_colors
  end
end
