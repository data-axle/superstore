module Superstore
  class Railtie < Rails::Railtie
    initializer "superstore.config" do |app|
      ActiveSupport.on_load :superstore do
        self.configurations = Rails.application.config.database_configuration
        establish_connection
      end
    end
  end
end
