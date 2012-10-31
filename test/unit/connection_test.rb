require 'test_helper'

class CassandraObject::ConnectionTest < CassandraObject::TestCase
  class TestObject < CassandraObject::Base
  end

  test "sanitize supports question marks" do
    assert_equal 'hello ?', CassandraCQL::Statement.sanitize('hello ?')
  end
end
