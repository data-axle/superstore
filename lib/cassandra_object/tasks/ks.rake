namespace :ks do
  desc 'Create the keyspace in cassandra_config/cassandra.yml for the current environment'
  task create: :environment do
    CassandraObject::Tasks::Keyspace.new.create cassandra_config['keyspace'], cassandra_config
    puts "Created keyspace: #{cassandra_config['keyspace']}"
  end

  namespace :schema do
    desc 'Create ks/schema.json file that can be portably used against any Cassandra instance supported by CassandraObject'
    task dump: :environment do
      schema_dump
    end

  end

  private
    def schema_dump(env = Rails.env)
      # File.open "#{Rails.root}/ks/schema.rb", 'w' do |file|
      # end
    end

    def schema_load(env = Rails.env)
    end

    def cassandra_config
      @cassandra_config ||= begin
        cassandra_configs = YAML.load_file(Rails.root.join("config", "cassandra.yml"))
        cassandra_configs[Rails.env || 'development']
      end
    end

    def get_keyspace
      ks = CassandraObject::Tasks::Keyspace.new
      ks.set cassandra_config['keyspace']
      ks
    end
end

