class JsonbInitializer
  def self.initialize!
    ActiveRecord::Migration.create_table :issues, id: :string do |t|
      t.jsonb :document, null: false
    end
  end
end

JsonbInitializer.initialize!
