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
    model = Class.new(Superstore::Base) do
      attribute :name, type: :string
    end
    record = model.new(name: 'John')

    assert_nil record.id
  end

  test 'set id' do
    issue = Issue.new id: 'foo'

    assert_equal 'foo', issue.id
  end

  test 'set id without primary key' do
    model = Class.new(Superstore::Base) do
      attribute :name, type: :string
    end

    assert_raises ActiveModel::MissingAttributeError do
      model.new(id: 'id')
    end
  end

  test 'attributes' do
    issue = Issue.new(id: 'lol')

    assert_not_nil issue.attributes['id']
  end

  test 'attributes without primary key' do
    model = Class.new(Superstore::Base) do
      attribute :name, type: :string
    end
    record = model.new(name: 'John')

    assert_nil record.attributes['id']
  end

  test 'has_primary_key?' do
    WithoutPrimaryKey = Class.new(Superstore::Base)
    refute WithoutPrimaryKey.has_primary_key?

    WithPrimaryKey = Class.new(Superstore::Base) { has_id }
    assert WithPrimaryKey.has_primary_key?
  end
end
