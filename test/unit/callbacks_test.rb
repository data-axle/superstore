require 'test_helper'

class Superstore::CallbacksTest < Superstore::TestCase
  class TestIssue < Superstore::Base
    self.table_name = 'issues'
    string :description

    %w(
      before_validation
      after_validation
      before_save
      after_save
      after_create
      after_update
      after_destroy
    ).each do |method|
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

    expected = %w(
      before_validation
      after_validation
      before_save
      after_create
      after_save
    )
    assert_equal expected, issue.callback_history
  end

  test 'update' do
    issue = TestIssue.create
    issue.reset_callback_history

    issue.update_attribute :description, 'foo'

    assert_equal %w(before_save after_update after_save), issue.callback_history
  end

  test 'destroy' do
    issue = TestIssue.create
    issue.reset_callback_history

    issue.destroy

    assert_equal ['after_destroy'], issue.callback_history
  end

  test 'new_record during callbacks' do
    class NewRecordTestClass < Superstore::Base
      self.table_name = 'issues'
      string :description

      before_create :expect_new_record
      before_save   :expect_new_record
      after_create  :refute_new_record
      after_save    :refute_new_record

      def expect_new_record
        raise "Expected new_record? to be true!" unless new_record?
      end

      def refute_new_record
        raise "Expected new_record? to be false!" if new_record?
      end
    end

    NewRecordTestClass.create
  end
end
