require 'rails'

I18n.config.enforce_available_locales = false
ActiveSupport::TestCase.test_order = :random

require 'active_record'
require 'rails/test_help'
require 'mocha/setup'

require 'superstore'

require 'support/pg'
require 'support/jsonb'
require 'support/models'

module Superstore
  class TestCase < ActiveSupport::TestCase
    def temp_object(&block)
      Class.new(Superstore::Base) do
        self.table_name = 'issues'
        has_id
        attribute :force_save, type: :string
        before_save { self.force_save = 'junk' }

        def self.name
          'Issue'
        end

        instance_eval(&block) if block_given?
      end
    end
  end

  module Types
    class TestCase < Superstore::TestCase
      attr_accessor :type
      setup do
        @type = self.class.name.sub(/Test$/, '').constantize.new
      end
    end
  end
end
