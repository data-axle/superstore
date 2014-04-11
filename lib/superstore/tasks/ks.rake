ks_namespace = namespace :ks do
  desc 'Create the keyspace in config/superstore.yml for the current environment'
  task create: :environment do
    begin
      Superstore::Schema.create_keyspace Superstore::Base.config[:keyspace], Superstore::Base.config[:keyspace_options]
    rescue Exception => e
      if e.message =~ /conflicts/
        p "Keyspace #{Superstore::Base.config[:keyspace]} already exists"
      else
        raise e
      end
    end
  end

  task drop: :environment do
    begin
      Superstore::Schema.drop_keyspace Superstore::Base.config[:keyspace]
    rescue Exception => e
      if e.message =~ /non existing keyspace/
        p "Keyspace #{Superstore::Base.config[:keyspace]} does not exist"
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
        Superstore::Schema.dump(file)
      end
    end

    task load: :environment do
      filename = ENV['SCHEMA'] || "#{Rails.root}/ks/structure.cql"
      File.open(filename) do |file|
        Superstore::Schema.load(file)
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
