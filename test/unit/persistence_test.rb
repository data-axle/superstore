#!/bin/env ruby
# encoding: utf-8

require 'test_helper'

class Superstore::PersistenceTest < Superstore::TestCase
  class Parent < Superstore::Base
    self.inheritance_column = 'document_type'
    attribute :document_type, type: :string

    def self.find_sti_class(type)
      Child
    end
  end

  class Child < Parent
    attribute :eye_color, type: :string
  end

  test 'instantiate with unknowns' do
    issue = Issue.instantiate('id' => 'theid', 'document' => {'z' => 'nooo', 'title' => 'Krazy'}.to_json)

    refute issue.attributes.key?('z')
    assert_equal 'Krazy', issue.attributes['title']
  end

  test 'instantiate with an inheritance column' do
    child = Parent.instantiate('id' => 'theid', 'document' => {'document_type' => 'child', 'eye_color' => 'blue'}.to_json)

    assert_kind_of Child, child
    assert_equal 'blue', child.eye_color
  end

  test 'instantiate when an inheritance column is expected but is nil' do
    child = Parent.instantiate('id' => 'theid', 'document' => { }.to_json)

    assert_kind_of Child, child
  end

  test 'persistence inquiries' do
    issue = Issue.new
    assert issue.new_record?
    assert !issue.persisted?

    issue.save
    assert issue.persisted?
    assert !issue.new_record?
  end

  test 'create' do
    issue = Issue.create { |i| i.description = 'foo' }
    assert_equal 'foo', issue.description
    assert_equal 'foo', Issue.find(issue.id).description
  end

  test 'read and write UTF' do
    utf = "\ucba1\ucba2\ucba3 ƒ´∑ƒ©√åµ≈√ˆअनुच्छेद´µøµø¬≤ 汉语漢語'".force_encoding(Encoding::UTF_8)

    issue = Issue.create { |i| i.description = utf }
    assert_equal utf, issue.description
    reloaded = Issue.find(issue.id).description
    assert_equal utf, reloaded
  end

  test 'save' do
    issue = Issue.new
    issue.save

    assert_equal issue, Issue.find(issue.id)
  end

  test 'save!' do
    klass = temp_object do
      attribute :description, type: :string
      validates :description, presence: true
    end

    record = klass.new(description: 'bad')
    record.save!

    assert_raise ActiveRecord::RecordInvalid do
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

  test 'update' do
    issue = Issue.create
    issue.update(description: 'lol')

    assert !issue.changed?
    assert_equal 'lol', issue.description
  end

  test 'update!' do
    begin
      Issue.validates(:description, presence: true)

      issue = Issue.new(description: 'bad')
      issue.save!

      assert_raise ActiveRecord::RecordInvalid do
        issue.update! description: ''
      end
    ensure
      Issue.reset_callbacks(:validate)
    end
  end

  test 'update nil attributes' do
    issue = Issue.create(title: "It's not fair!'", description: 'lololol')

    issue.update title: nil

    issue = Issue.find issue.id
    assert_nil issue.title
  end

  test 'becomes' do
    klass = temp_object

    assert_kind_of klass, Issue.new.becomes(klass)
  end

  test 'becomes includes changed_attributes' do
    klass = temp_object do
      attribute :title, type: :string
    end

    issue = Issue.new(title: 'Something is wrong')
    other = issue.becomes(klass)

    assert_equal 'Something is wrong', other.title
    assert_equal %w(title), other.changed
  end

  test 'reload' do
    persisted_issue = Issue.create
    fresh_issue = Issue.find(persisted_issue.id)
    fresh_issue.update_attribute(:description, "It's not fair!")

    reloaded_issue = persisted_issue.reload
    assert_equal "It's not fair!", persisted_issue.description
    assert_equal persisted_issue, reloaded_issue
  end

  test 'delete' do
    klass = temp_object do
      attribute :name, type: :string
    end

    record = klass.new(name: 'cool')
    record.save!

    id = record.id
    assert_equal id, klass.find(id).id

    klass.delete(id)

    assert_raise ActiveRecord::RecordNotFound do
      klass.find(id)
    end
  end

  test 'delete multiple' do
    klass = temp_object do
      attribute :name, type: :string
    end

    ids = []
    (1..10).each do
      record = klass.create!(name: 'cool')
      ids << record.id
    end

    klass.delete(ids)

    assert_equal [], klass.where(id: ids)
  end

  test 'find_by_id' do
    Issue.create.tap do |issue|
      assert_equal issue, Issue.find_by_id(issue.id)
    end

    assert_nil Issue.find_by_id('what')
  end

  test 'saves non-superstore column' do
    i = Issue.new
    i.widget_id = 100
    i.description = 'Abraham Lincoln'
    i.save!

    saved_record = ActiveRecord::Base.connection.select_one("SELECT * FROM #{Issue.table_name} WHERE #{Issue.primary_key} = '#{i.id}'")
    assert_equal i.id, saved_record['id']
    json = JSON.parse(saved_record['document'])
    assert_equal %w(created_at description updated_at), json.keys.sort
    assert_equal 100, saved_record['widget_id']

    saved_record = Issue.find(i.id)
    assert_equal i.id, saved_record.id
    assert_equal 'Abraham Lincoln', saved_record.description
    assert_equal 100, saved_record.widget_id
  end
end
