require 'test_helper'

class Superstore::AttributeMethods::DefinitionTest < Superstore::TestCase
  class TestType < Superstore::Types::BaseType
    def typecast(v)
      "#{v}-foo"
    end
  end

  test 'initialize' do
    definition = Superstore::AttributeMethods::Definition.new(Issue, :foo, TestType, {})

    assert_equal 'foo', definition.name
    assert_kind_of TestType, definition.type
  end
end
