require 'test_helper'

class Superstore::SerializationTest < Superstore::TestCase
  test 'as_json' do
    issue = Issue.new
    expected = {"id" => issue.id}

    assert_equal expected, issue.as_json
  end
end