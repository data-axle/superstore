class Issue < CassandraObject::Base
  key :uuid
  string :description
end