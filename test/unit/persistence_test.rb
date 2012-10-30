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

  test "batch" do
    first_issue = second_issue = nil

    Issue.batch do
      first_issue = Issue.create
      second_issue = Issue.create

      assert_raise(CassandraObject::RecordNotFound) { Issue.find(first_issue.id) }
      assert_raise(CassandraObject::RecordNotFound) { Issue.find(second_issue.id) }
    end

    assert_nothing_raised(CassandraObject::RecordNotFound) { Issue.find(first_issue.id) }
    assert_nothing_raised(CassandraObject::RecordNotFound) { Issue.find(second_issue.id) }
  end

  test "batch state" do
    first_issue = Issue.create

    assert !Issue.batching?
    Issue.batch_start

    second_issue = Issue.create
    assert Issue.batching?

    assert_nothing_raised(CassandraObject::RecordNotFound) { Issue.find(first_issue.id) }
    assert_raise(CassandraObject::RecordNotFound) { Issue.find(second_issue.id) }

    Issue.batch_end

    assert_nothing_raised(CassandraObject::RecordNotFound) { Issue.find(second_issue.id) }

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

  test 'update nil attributes' do
    issue = Issue.create(title: 'I rule', description: 'lololol')

    issue.update_attributes title: nil

    issue = Issue.find issue.id
    assert_nil issue.title
  end

  test 'becomes' do
    klass = temp_object do
    end

    assert_kind_of klass, Issue.new.becomes(klass)
  end

  test 'reload' do
    persisted_issue = Issue.create
    fresh_issue = Issue.find(persisted_issue.id)
    fresh_issue.update_attribute(:description, 'say what')

    reloaded_issue = persisted_issue.reload
    assert_equal 'say what', persisted_issue.description
    assert_equal persisted_issue, reloaded_issue
  end

  test 'delete with consistency' do
    issue = Issue.create
    Issue.with_consistency 'QUORUM' do
      issue.destroy
    end
  end

  test 'insert with consistency' do
    Issue.with_consistency 'QUORUM' do
      Issue.create
    end
  end

  test 'allow CQL keyword in column name' do
    assert_nothing_raised do
      Issue.string :text
      issue = Issue.create :text => 'hello'
      issue.text = 'world'
      issue.save!
      issue.text = nil
      issue.save!
    end
  end

  test 'quote_columns' do
    klass = Class.new { include CassandraObject::Persistence }
    assert_equal %w{'a' 'b'}, klass.__send__(:quote_columns, %w{a b})
  end
end
