require 'test_helper'

class CassandraObject::CallbacksTest < CassandraObject::TestCase
  class TestIssue < CassandraObject::Base
    self.column_family = 'Issues'
    key :uuid
    string :description

    %w(after_save after_create after_update after_destroy).each do |method|
      send(method) do
        callback_history << method
      end
    end

    def reset_callback_history
      @callback_history = []
    end

    def callback_history
      @callback_history ||= []
    end
  end

  test 'create' do
    issue = TestIssue.create

    assert_equal ['after_create', 'after_save'], issue.callback_history
  end

  test 'update' do
    issue = TestIssue.create
    issue.reset_callback_history

    issue.update_attribute :description, 'foo'

    assert_equal ['after_update', 'after_save'], issue.callback_history
  end

  test 'destroy' do
    issue = TestIssue.create
    issue.reset_callback_history

    issue.destroy

    assert_equal ['after_destroy'], issue.callback_history
  end
end