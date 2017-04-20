module Superstore
  class Railtie < Rails::Railtie
    initializer "superstore.config" do |app|
      ActiveSupport.on_load :superstore do
        establish_connection
      end
    end
  end
end
