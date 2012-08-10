class Issue < CassandraObject::Base
  string :description
  string :title
  before_create { self.description ||= 'funny' }
end