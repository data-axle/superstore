class Issue < CassandraObject::Base
  string :description
  string :title
  before_create { self.description ||= 'funny' }

  def self.for_key key
    where('KEY' => key)
  end
end
