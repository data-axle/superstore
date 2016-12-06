class User < ActiveRecord::Base
end

class Label < ActiveRecord::Base
end

class Issue < Superstore::Base
  string :description
  string :title
  json :comments

  before_create { self.description ||= 'funny' }

  has_many :labels

  def self.for_key key
    where_ids(key)
  end
end

