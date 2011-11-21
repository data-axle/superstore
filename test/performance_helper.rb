require 'bundler/setup'
require 'minitest/autorun'
Bundler.require(:default, :test)

module CassandraObject
  class PerformanceTest < ActiveSupport::TestCase
  end
end