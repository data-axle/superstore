module Superstore
  module Caching
    extend ActiveSupport::Concern

    def cache_key
      if new_record?
        "#{self.class.model_name.cache_key}/new"
      else
        "#{self.class.model_name.cache_key}/#{id}-#{updated_at}"
      end
    end
  end
end
