require 'test_helper'

class Superstore::Associations::BelongsTest < Superstore::TestCase
  class TestObject < Superstore::Base
    self.table_name = 'issues'
    attribute :user_id, type: :string
    belongs_to :user, primary_key: :special_id
  end

  test 'belongs_to' do
    user = User.create(special_id: 'abc')
    issue = TestObject.create(user: user)

    assert_equal user, issue.user
    assert_equal issue.user_id, 'abc'

    issue = TestObject.find(issue.id)
    assert_equal user, issue.user
  end

  test 'belongs_to clear cache after reload' do
    user = User.create(special_id: 'abc')
    issue = TestObject.create(user: user)
    user.destroy

    assert_not_nil issue.user
    assert_nil TestObject.find(issue.id).user
    assert_nil issue.reload.user
  end
end
