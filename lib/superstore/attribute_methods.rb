module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern

    included do
      # include ActiveRecord::AttributeMethods

      # extend ClassOverrides
      include PrimaryKey
    end
  end
end
