Superstore::Base.config = {'adapter' => 'jsonb'}

class JsonbInitializer
  def self.initialize!
    Superstore::Base.adapter.create_table('issues')
    Superstore::Base.adapter.define_jsonb_functions!
  end
end

JsonbInitializer.initialize!
