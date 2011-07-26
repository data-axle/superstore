require 'test_helper'

class CassandraObject::BaseTest < CassandraObject::TestCase
  class Son < CassandraObject::Base
  end

  class Grandson < Son
  end
  
  test 'base_class' do
    assert_equal Son, Son.base_class
    assert_equal Son, Grandson.base_class
  end

  test 'column family' do
    assert_equal 'CassandraObject::BaseTest::Sons', Son.column_family
  end

  test 'to_param' do
    issue = Issue.create
    assert_equal issue.id, issue.to_param
  end
  
  test 'hash' do
    issue = Issue.create
    assert_equal issue.id.hash, issue.hash
  end
end