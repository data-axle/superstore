require 'test_helper'

class CassandraObject::IdentiyTest < CassandraObject::TestCase
  test 'equality of new records' do
    assert_not_equal Issue.new, Issue.new
  end
end