require 'test_helper'

class CassandraObject::ValidationsTest < CassandraObject::TestCase
  test 'create!' do
    begin
      Issue.validates(:description, presence: true)

      Issue.create!(description: 'lol')

      assert_raise(CassandraObject::RecordInvalid) { Issue.create!(description: '') }
    ensure
      Issue.reset_callbacks(:validate)
    end
  end

  test 'save!' do
    begin
      Issue.validates(:description, presence: true)

      Issue.new(description: 'lol').save!

      assert_raise(CassandraObject::RecordInvalid) { Issue.new(description: '').save! }
    ensure
      Issue.reset_callbacks(:validate)
    end
  end
end