require 'test_helper'

class Superstore::ConnectionTest < Superstore::TestCase
  class TestObject < Superstore::Base
  end

  test "sanitize supports question marks" do
    assert_equal 'hello ?', CassandraCQL::Statement.sanitize('hello ?')
  end
end
