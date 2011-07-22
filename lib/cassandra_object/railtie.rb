module CassandraObject
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'cassandra_object/tasks/ks.rake'
    end

    generators do
      require 'cassandra_object/generators/migration_generator'
    end
  end
end