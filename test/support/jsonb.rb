class JsonbInitializer
  def self.initialize!
    Superstore::Base.adapter.create_table('issues')
  end
end

JsonbInitializer.initialize!
