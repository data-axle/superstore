ks_namespace = namespace :ks do
  desc 'Create the keyspace in cassandra_config/cassandra.yml for the current environment'
  task create: :environment do
    CassandraObject::Schema.create_keyspace cassandra_config['keyspace']
  end

  task drop: :environment do
    CassandraObject::Schema.drop_keyspace cassandra_config['keyspace']
  end

  task reset: [:drop, :setup]

  task setup: :create do
    filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
    CassandraObject::Schema.load(filename)
  end

  namespace :structure do
    task dump: :environment do
      filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
      File.open(filename, "w:utf-8") do |file|
        CassandraObject::Schema.dump(file)
      end
    end
  end

  task :_dump do
    ks_namespace["structure:dump"].invoke
  end

  private
    def cassandra_config
      @cassandra_config ||= begin
        cassandra_configs = YAML.load_file(Rails.root.join("config", "cassandra.yml"))
        cassandra_configs[Rails.env || 'development']
      end
    end
end
