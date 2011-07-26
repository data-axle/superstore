module CassandraObject
  module PrimaryKey
    def id
      key.to_s
    end

    def id=(key)
      self.key = self.class.parse_key(key)
      id
    end
  end
end
