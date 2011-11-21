require 'test_helper'

class CassandraObject::AttributeMethods::DirtyTest < CassandraObject::TestCase
  test 'save clears dirty' do
    record = temp_object do
      string :name
    end.new name: 'foo'
    
    assert record.changed?

    record.save!

    assert !record.changed?
  end

  test 'reload clears dirty' do
    record = temp_object do
      string :name
    end.create! name: 'foo'

    record.name = 'bar'
    assert record.changed?

    record.reload

    assert !record.changed?
  end

  test 'typecast float before dirty check' do
    record = temp_object do
      float :price
    end.create(price: 5.01)

    record.price = '5.01'
    assert !record.changed?

    record.price = '7.12'
    assert record.changed?
  end

  test 'boolean' do
    record = temp_object do
      boolean :awesome
    end.create(awesome: false)
    
    record.awesome = false
    assert !record.changed?

    record.awesome = true
    assert record.changed?
  end
end