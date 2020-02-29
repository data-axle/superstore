require 'test_helper'

class Superstore::AttributeMethods::PrimaryKeyTest < Superstore::TestCase
  test 'get id' do
    model = temp_object do
      key do
        "foo"
      end
    end
    record = model.new

    assert_equal 'foo', record.id
  end

  test 'get id without primary key' do
    person = Person.new(name: 'John')

    assert_nil person.id
  end

  test 'set id' do
    issue = Issue.new id: 'foo'

    assert_equal 'foo', issue.id
  end

  test 'set id without primary key' do
    assert_raises ActiveModel::MissingAttributeError do
      Person.new(id: 'id')
    end
  end

  test 'attributes' do
    issue = Issue.new(id: 'lol')

    assert_not_nil issue.attributes['id']
  end

  test 'attributes without primary key' do
    person = Person.new(name: 'John')

    assert_nil person.attributes['id']
  end

  test 'has_primary_key?' do
    assert Issue.has_primary_key?
    refute Person.has_primary_key?
  end
end
