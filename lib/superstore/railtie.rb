module Superstore
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'superstore/tasks/ks.rake'
    end

    initializer "superstore.config" do |app|
      ActiveSupport.on_load :superstore do
        pathname = Rails.root.join('config', 'superstore.yml')
        if pathname.exist?
          config = ERB.new(pathname.read).result
          config = YAML.load(config)

          if config = config[Rails.env]
            self.config = config.symbolize_keys!
          else
            raise "Missing environment #{Rails.env} in superstore.yml"
          end
        end
      end
    end
  end
end
