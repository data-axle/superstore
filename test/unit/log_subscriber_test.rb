require "test_helper"
require "active_support/log_subscriber/test_helper"
require "superstore/log_subscriber"

class Superstore::LogSubscriberTest < Superstore::TestCase
  include ActiveSupport::LogSubscriber::TestHelper

  def setup
    super

    Superstore::LogSubscriber.attach_to :cassandra_object
  end

  def test_cql_notification
    Issue.adapter.execute "SELECT * FROM Issues"

    wait

    assert_equal 1, @logger.logged(:debug).size
    assert_match "SELECT * FROM Issues", @logger.logged(:debug)[0]
  end

  def test_initializes_runtime
    Thread.new { assert_equal 0, Superstore::LogSubscriber.runtime }.join
  end
end
