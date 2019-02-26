module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern

    included do
      include PrimaryKey
    end
  end
end
