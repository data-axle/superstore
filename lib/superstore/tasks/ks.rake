ks_namespace = namespace :ks do
  desc 'Create the keyspace in config/superstore.yml for the current environment'
  task create: :environment do
    begin
      Superstore::CassandraSchema.create_keyspace Superstore::Base.config[:keyspace], Superstore::Base.config[:keyspace_options]
    rescue Exception => e
      if e.message =~ /conflicts/
        p "Keyspace #{Superstore::Base.config[:keyspace]} already exists"
      else
        raise e
      end
    end
  end

  desc 'Remove the keyspace in config/superstore.yml for the current environment'
  task drop: :environment do
    begin
      Superstore::CassandraSchema.drop_keyspace Superstore::Base.config[:keyspace]
    rescue Exception => e
      if e.message =~ /non existing keyspace/
        p "Keyspace #{Superstore::Base.config[:keyspace]} does not exist"
      else
        raise e
      end
    end
  end

  desc 'Alias for ks:drop and ks:setup'
  task reset: [:drop, :setup]

  desc 'Alias for ks:create and ks:structure:load'
  task setup: [:create, :_load]

  namespace :structure do
    desc 'Serialize the current structure for the keyspace in config/superstore.yml to the SCHEMA environment variable (defaults to "$RAILS_ROOT/ks/structure.cql")'
    task dump: :environment do
      filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
      File.open(filename, "w:utf-8") do |file|
        Superstore::CassandraSchema.dump(file)
      end
    end

    desc 'Load the structure for the keyspace in config/superstore.yml from the SCHEMA environment variable (defaults to "$RAILS_ROOT/ks/structure.cql")'
    task load: :environment do
      filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
      File.open(filename) do |file|
        Superstore::CassandraSchema.load(file)
      end
    end
  end

  task :_dump do
    ks_namespace["structure:dump"].invoke
  end

  task :_load do
    ks_namespace["structure:load"].invoke
  end
end
