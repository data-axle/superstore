module Superstore
  class Railtie < Rails::Railtie
    initializer "superstore.config" do |app|
      ActiveSupport.on_load :superstore do
        self.configurations = Rails.application.config.database_configuration
        establish_connection
      end

      ActiveSupport.on_load :active_record do
        ActiveRecord::Relation.class_eval do
          include Superstore::Relation::Scrolling
        end
      end
    end
  end
end
