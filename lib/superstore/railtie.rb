module Superstore
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'superstore/tasks/ks.rake'
    end

    initializer "superstore.config" do |app|
      ActiveSupport.on_load :superstore do
        pathnames = [Rails.root.join('config', 'superstore.yml'), Rails.root.join('config', 'cassandra.yml')]
        if pathname = pathnames.detect(&:exist?)
          config = YAML.load(pathname.read)

          if config = config[Rails.env]
            self.config = config.symbolize_keys!
          else
            raise "Missing environment #{Rails.env} in superstore.yml"
          end
        end
      end
    end

    # Expose database runtime to controller for logging.
    initializer "superstore.log_runtime" do |app|
      require "superstore/railties/controller_runtime"
      ActiveSupport.on_load(:action_controller) do
        include Superstore::Railties::ControllerRuntime
      end
    end
  end
end
