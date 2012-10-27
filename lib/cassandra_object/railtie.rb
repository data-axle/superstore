module CassandraObject
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'cassandra_object/tasks/ks.rake'
    end
  end
end
