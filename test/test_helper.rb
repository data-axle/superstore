require 'bundler/setup'
Bundler.require(:default, :test)

I18n.config.enforce_available_locales = false

require 'active_record'
require 'rails/test_help'
require 'mocha/setup'

ActiveSupport::TestCase.test_order = :random

require 'support/pg'
require 'support/jsonb'
require 'support/issue'
require 'support/user'

def MiniTest.filter_backtrace(bt)
  bt
end

module Superstore
  class TestCase < ActiveSupport::TestCase
    def temp_object(&block)
      Class.new(Superstore::Base) do
        self.table_name = 'Issues'
        string :force_save
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
        @type = self.class.name.sub(/Test$/, '').constantize.new(Issue)
      end
    end
  end
end
