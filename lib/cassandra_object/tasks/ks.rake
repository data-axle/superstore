namespace :ks do
  desc 'Create the keyspace in cassandra_config/cassandra.yml for the current environment'
  task create: :environment do
    CassandraObject::Tasks::Keyspace.new.create cassandra_config['keyspace'], cassandra_config
    puts "Created keyspace: #{cassandra_config['keyspace']}"
  end

  desc 'Drop keyspace in cassandra_config/cassandra.yml for the current environment'
  task drop: :environment do
    CassandraObject::Tasks::Keyspace.new.drop cassandra_config['keyspace']
    puts "Dropped keyspace: #{cassandra_config['keyspace']}"
  end

  desc 'Migrate the keyspace (options: VERSION=x)'
  task migrate: :environment do
    version = ( ENV['VERSION'] ? ENV['VERSION'].to_i : nil )
    CassandraObject::Schema::Migrator.migrate CassandraObject::Schema::Migrator.migrations_path, version
    schema_dump
  end

  namespace :migrate do
    task :reset => ["ks:drop", "ks:create", "ks:migrate"]
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n)'
  task rollback: :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    CassandraObject::Schema::Migrator.rollback CassandraObject::Schema::Migrator.migrations_path, step
    schema_dump
  end

  desc 'Pushes the schema to the next version (specify steps w/ STEP=n)'
  task forward: :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    CassandraObject::Schema::Migrator.forward CassandraObject::Schema::Migrator.migrations_path, step
    schema_dump
  end

  namespace :schema do
    desc 'Create ks/schema.json file that can be portably used against any Cassandra instance supported by CassandraObject'
    task dump: :environment do
      schema_dump
    end

  end

  namespace :test do
    desc 'Load the development schema in to the test keyspace'
    task prepare: :environment do
      schema_dump :development
      schema_load :test
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

