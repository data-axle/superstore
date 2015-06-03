require 'test_helper'

class Superstore::AttributeMethods::DefinitionTest < Superstore::TestCase
  class TestType < Superstore::Types::BaseType
  end

  test 'typecast' do
    definition = Superstore::AttributeMethods::Definition.new(Issue, :foo, TestType, default: 'foo')

    assert_equal 'foo', definition.name
    assert_kind_of TestType, definition.type
  end
end
