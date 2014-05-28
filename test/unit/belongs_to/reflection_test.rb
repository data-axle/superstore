require 'test_helper'

class Superstore::BelongsTo::ReflectionTest < Superstore::TestCase
  class ::Status < Superstore::Base; end
  class ::Job < Superstore::Base
    belongs_to :status
  end

  test 'class_name' do
    assert_equal 'Status', Job.new.belongs_to_reflections[:status].class_name
  end
end
