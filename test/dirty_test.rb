require 'test_helper'

class CassandraObject::DirtyTest < CassandraObject::TestCase
  class TestRecord < CassandraObject::Base
    key :uuid
    self.column_family = 'Issues'
    string :name
  end

  test 'save clears dirty' do
    record = TestRecord.new(name: 'foo')
    assert record.changed?

    record.save

    assert !record.changed?
  end
end