require 'test_helper'

class Superstore::AttributeMethods::DefinitionTest < Superstore::TestCase
  class TestType < Superstore::Types::BaseType
  end

  test 'typecast' do
    definition = Superstore::AttributeMethods::Definition.new(:foo, TestType, {a: :b})

    assert_equal 'foo', definition.name
    assert_kind_of TestType, definition.coder
  end
end
