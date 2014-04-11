class Issue < Superstore::Base
  string :description
  string :title

  before_create { self.description ||= 'funny' }

  def self.for_key key
    where_ids(key)
  end
end
