require 'test_helper'

class Superstore::Associations::HasManyTest < Superstore::TestCase
  class TestObject < Issue
    has_one :favorite_label, class_name: 'Label'
  end

  test 'has_many' do
    issue = TestObject.create!
    label = Label.create! name: 'important', issue_id: issue.id

    assert_equal [label], issue.favorite_label
  end
end
