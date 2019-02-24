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

  class ModelWithOverride < Superstore::Base
    attribute :title, type: :string

    def title=(v)
      super "#{v} lol"
    end
  end

  test 'override' do
    issue = ModelWithOverride.new(title: 'hey')

    assert_equal 'hey lol', issue.title
  end

  class ReservedWord < Superstore::Base
    attribute :system, type: :string
  end

  test 'reserved words' do
    r = ReservedWord.new(system: 'hello')
    assert_equal 'hello', r.system
  end

  test 'has_attribute?' do
    refute Issue.new.has_attribute?(:unknown)
    assert Issue.new.has_attribute?(:description)
    assert Issue.new(description: nil).has_attribute?(:description)
    assert Issue.new(description: 'hey').has_attribute?(:description)
  end
end
