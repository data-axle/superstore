require 'test_helper'

class Superstore::SerializationTest < Superstore::TestCase
  test 'as_json' do
    issue = Issue.new(skill_level_required: 100..200)
    expected = {
      "id" => issue.id,
      "skill_level_required" => [100, 200]
    }

    assert_equal expected, issue.as_json
  end
end
