require 'test_helper'

class Superstore::Associations::ReflectionTest < Superstore::TestCase
  test 'reflect_on_associations' do
    assert_equal %i(labels children_issues parent_issue), Issue.reflect_on_all_associations.map(&:name)
  end

  test 'reflections' do
    assert_instance_of ActiveRecord::Reflection::HasManyReflection, Issue.reflections['labels']
  end
end
