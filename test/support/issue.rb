class Issue < CassandraObject::Base
  string :description
  before_save { self.description ||= 'funny' }
end