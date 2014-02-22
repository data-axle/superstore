ks_namespace = namespace :ks do
  desc 'Create the keyspace in config/cassandra.yml for the current environment'
  task create: :environment do
    begin
      CassandraObject::Schema.create_keyspace CassandraObject::Base.config[:keyspace], CassandraObject::Base.config[:keyspace_options]
    rescue Exception => e
      if e.message =~ /conflicts/
        p "Keyspace #{CassandraObject::Base.config[:keyspace]} already exists"
      else
        raise e
      end
    end
  end

  task drop: :environment do
    begin
      CassandraObject::Schema.drop_keyspace CassandraObject::Base.config[:keyspace]
    rescue Exception => e
      if e.message =~ /non existing keyspace/
        p "Keyspace #{CassandraObject::Base.config[:keyspace]} does not exist"
      else
        raise e
      end
    end
  end

  task reset: [:drop, :setup]

  task setup: [:create, :_load]

  namespace :structure do
    task dump: :environment do
      filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
      File.open(filename, "w:utf-8") do |file|
        CassandraObject::Schema.dump(file)
      end
    end

    task load: :environment do
      filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
      File.open(filename) do |file|
        CassandraObject::Schema.load(file)
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
