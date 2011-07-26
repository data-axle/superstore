module CassandraObject
  class CasssandraObjectError < StandardError
  end

  class RecordNotSaved < CasssandraObjectError
  end
  
  class RecordNotFound < CasssandraObjectError
  end
end