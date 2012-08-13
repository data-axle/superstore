require "test_helper"
require "active_support/log_subscriber/test_helper"

class CassandraObject::LogSubscriberTest < ActiveRecord::TestCase
  include ActiveSupport::LogSubscriber::TestHelper
  