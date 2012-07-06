require 'test_helper'

class CassandraObject::PersistenceTest < CassandraObject::TestCase
  test 'encode_attributes' do
    klass = temp_object do
      string :description
    end
    
    assert_equal(
      {},
      klass.encode_attributes({})
    )

    assert_equal(
      {},
      klass.encode_attributes({description: nil})
    )

    assert_equal(
      {'description' => 'lol'},
      klass.encode_attributes({description: 'lol'})
    )
  end

  test 'persistance inquiries' do
    issue = Issue.new
    assert issue.new_record?
    assert !issue.persisted?

    issue.save
    assert issue.persisted?
    assert !issue.new_record?
  end

  test 'save' do
    issue = Issue.new
    issue.save

    assert_equal issue, Issue.find(issue.id)
  end

  test 'save!' do
    klass = temp_object do
      string :description
      validates :description, presence: true
    end
    
    record = klass.new(description: 'bad')
    record.save!

    assert_raise CassandraObject::RecordInvalid do
      record = klass.new
      record.save!
    end
  end

  test 'destroy' do
    issue = Issue.create
    issue.destroy
 
    assert issue.destroyed?
    assert !issue.persisted?
    assert !issue.new_record?
  end

  test 'update_attribute' do
    issue = Issue.create
    issue.update_attribute(:description, 'lol')

    assert !issue.changed?
    assert_equal 'lol', issue.description
  end
  
  test 'update_attributes' do
    issue = Issue.create
    issue.update_attributes(description: 'lol')

    assert !issue.changed?
    assert_equal 'lol', issue.description
  end

  test 'update_attributes!' do
    begin
      Issue.validates(:description, presence: true)

      issue = Issue.new(description: 'bad')
      issue.save!
      
      assert_raise CassandraObject::RecordInvalid do
        issue.update_attributes! description: ''
      end
    ensure
      Issue.reset_callbacks(:validate)
    end
  end

  test 'reload' do
    persisted_issue = Issue.create
    fresh_issue = Issue.find(persisted_issue.id)
    fresh_issue.update_attribute(:description, 'say what')

    persisted_issue.reload
    assert_equal 'say what', persisted_issue.description
  end
end