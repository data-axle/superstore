require 'test_helper'

class CassandraObject::AttributeMethods::DefinitionTest < CassandraObject::TestCase
  class TestType < CassandraObject::Types::BaseType
  end

  test 'typecast' do
    definition = CassandraObject::AttributeMethods::Definition.new(:foo, TestType, {a: :b})

    assert_equal 'foo', definition.name
    assert_kind_of TestType, definition.coder
  end
end
