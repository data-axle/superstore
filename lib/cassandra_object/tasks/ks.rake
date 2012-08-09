namespace :ks do
  desc 'Create the keyspace in cassandra_config/cassandra.yml for the current environment'
  task create: :environment do
    CassandraObject::Schema.create_keyspace cassandra_config['keyspace']
  end

  task drop: :environment do
    CassandraObject::Schema.drop_keyspace cassandra_config['keyspace']
  end

  private
    def cassandra_config
      @cassandra_config ||= begin
        cassandra_configs = YAML.load_file(Rails.root.join("config", "cassandra.yml"))
        cassandra_configs[Rails.env || 'development']
      end
    end
end
