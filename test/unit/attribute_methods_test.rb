require 'test_helper'

class Superstore::AttributeMethodsTest < Superstore::TestCase
  test 'read and write attributes' do
    issue = Issue.new
    assert_nil issue.read_attribute(:description)

    issue.write_attribute(:description, nil)
    assert_nil issue.read_attribute(:description)

    issue.write_attribute(:description, 'foo')
    assert_equal 'foo', issue.read_attribute(:description)
  end

  test 'read primary_key' do
    refute_nil Issue.new[:id]
  end

  test 'hash accessor aliases' do
    issue = Issue.new

    issue[:description] = 'bar'

    assert_equal 'bar', issue[:description]
  end

  test 'attributes setter' do
    issue = Issue.new

    issue.attributes = {
      description: 'foo'
    }

    assert_equal 'foo', issue.description
  end

  class ChildIssue < Issue
    def title=(val)
      self[:title] = val + ' lol'
    end
  end

  test 'override' do
    issue = ChildIssue.new(title: 'hey')

    assert_equal 'hey lol', issue.title
  end

  class ReservedWord < Superstore::Base
    self.table_name = 'issues'
    string :system
  end

  test 'reserved words' do
    r = ReservedWord.new(system: 'hello')
    assert_equal 'hello', r.system
  end

  test 'has_attribute?' do
    refute Issue.new.attribute_exists?(:description)
    assert Issue.new(description: nil).has_attribute?(:description)
    assert Issue.new(description: false).has_attribute?(:description)
    assert Issue.new(description: 'hey').has_attribute?(:description)
  end
end
