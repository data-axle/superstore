class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class User < ApplicationRecord
end

class Label < ApplicationRecord
  belongs_to :issue
end

class Issue < Superstore::Base
  attribute :description, type: :string
  attribute :title, type: :string
  attribute :parent_issue_id, type: :string
  attribute :comments, type: :json
  attribute :created_at, type: :time
  attribute :updated_at, type: :time

  before_create { self.description ||= 'funny' }

  has_many :labels, inverse_of: :issue
  has_many :children_issues, class_name: 'Issue', foreign_key: :parent_issue_id, inverse_of: :parent_issue, superstore: true
  belongs_to :parent_issue, class_name: 'Issue', superstore: true

  def self.for_key key
    where_ids(key)
  end
end
