require 'test_helper'

class Superstore::BelongsTo::ReflectionTest < Superstore::TestCase
  class ::Status < Superstore::Base; end
  class ::User < Superstore::Base
    belongs_to :status
  end

  test 'class_name' do
    assert_equal 'Status', User.new.belongs_to_reflections[:status].class_name
  end
end
