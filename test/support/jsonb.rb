class JsonbInitializer
  def self.initialize!
    ActiveRecord::Migration.create_table :issues, id: :string do |t|
      t.jsonb :document, null: false
      t.integer :widget_id
    end
  end
end

JsonbInitializer.initialize!
