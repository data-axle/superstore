module CassandraObject
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'cassandra_object/tasks/ks.rake'
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
