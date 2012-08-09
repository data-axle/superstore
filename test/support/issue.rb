class Issue < CassandraObject::Base
  string :description
  string :title
  before_save { self.description ||= 'funny' }
end