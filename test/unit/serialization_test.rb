require 'test_helper'

class Superstore::SerializationTest < Superstore::TestCase
  test 'as_json' do
    issue = Issue.new
    expected = {
      "widget_id"   => nil,
      "id"          => issue.id,
      "created_at"  => nil,
      "updated_at"  => nil,
      "description" => nil,
      "title"       => nil,
      "parent_issue_id" => nil,
      "comments"    => nil
    }

    assert_equal expected, issue.as_json
  end
end
