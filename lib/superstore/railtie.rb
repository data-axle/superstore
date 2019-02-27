module Superstore
  class Railtie < Rails::Railtie
    initializer "superstore.config" do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Relation.class_eval do
          include Superstore::Relation::Scrolling
        end
      end
    end
  end
end
