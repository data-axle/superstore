class User < ActiveRecord::Base
end

class Label < ActiveRecord::Base
  belongs_to :issue
end

class Issue < Superstore::Base
  string :description
  string :title
  string :parent_issue_id
  integer_range :skill_level_required
  json :comments

  before_create { self.description ||= 'funny' }

  has_many :labels, inverse_of: :issue
  has_many :children_issues, class_name: 'Issue', foreign_key: :parent_issue_id, inverse_of: :parent_issue, superstore: true
  belongs_to :parent_issue, class_name: 'Issue', superstore: true

  def self.for_key key
    where_ids(key)
  end
end
