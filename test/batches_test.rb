require 'test_helper'

class CassandraObject::BatchesTest < CassandraObject::TestCase
  test 'find_each' do
    Issue.create 
    Issue.create 

    issues = []
    Issue.find_each do |issue|
      issues << issue
    end

    assert_equal Issue.all.to_set, issues.to_set
  end
end