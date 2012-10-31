require 'test_helper'

class CassandraObject::BelongsTo::ReflectionTest < CassandraObject::TestCase
  test '#class_name' do
    class ::Status < CassandraObject::Base; end
    class ::User < CassandraObject::Base
      belongs_to :status
    end

    assert_equal 'Status', User.new.belongs_to_reflections[:status].class_name
  end
end
