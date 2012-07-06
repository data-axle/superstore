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
    assert_equal 'CassandraObject::BaseTest::Sons', Grandson.column_family
  end

  test 'initialiaze' do
    issue = Issue.new
    
    assert issue.new_record?
    assert !issue.destroyed?
  end

  test 'equality of new records' do
    assert_not_equal Issue.new, Issue.new
  end

  test 'equality' do
    first_issue = Issue.create description: 'poop'
    second_issue = Issue.create description: 'poop'

    assert_equal first_issue, first_issue
    assert_equal first_issue, Issue.find(first_issue.id)
    assert_not_equal first_issue, second_issue
  end

  test 'to_param' do
    issue = Issue.new
    assert_equal issue.id, issue.to_param
  end
  
  test 'hash' do
    issue = Issue.create
    assert_equal issue.id.hash, issue.hash
  end
end