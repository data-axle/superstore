module CassandraObject
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'cassandra_object/tasks/ks.rake'
    end

    initializer "cassandra_object.log_runtime" do |app|
      ActiveSupport.on_load :cassandra_object do
        pathname = Rails.root.join('config', 'cassandra.yml')
        if pathname.exist?
          config = YAML.load(pathname.read)

          if config = config[Rails.env]
            self.config = {
              keyspace: config['keyspace'],
              servers: config['servers'],
              thrift: config['thrift']
            }
          else
            raise "Missing environment #{Rails.env} in cassandra.yml"
          end
        end
      end
    end

    # Expose database runtime to controller for logging.
    initializer "cassandra_object.log_runtime" do |app|
      require "cassandra_object/railties/controller_runtime"
      ActiveSupport.on_load(:action_controller) do
        include CassandraObject::Railties::ControllerRuntime
      end
    end
  end
end
