require 'test_helper'
require "superstore/railties/controller_runtime"

class Superstore::Railties::ControllerRuntimeTest < MiniTest::Unit::TestCase
  class TestRuntime
    def self.log_process_action(payload)
      ['sweet']
    end

    def cleanup_view_runtime
      12
    end

    def append_info_to_payload(payload)
      payload[:foo] = 42
    end
  end

  class CassandraRuntime < TestRuntime
    include Superstore::Railties::ControllerRuntime
  end

  def test_cleanup_view_runtime
    runtime = CassandraRuntime.new
    Superstore::LogSubscriber.runtime = 10

    runtime.cleanup_view_runtime

    assert_equal 0, Superstore::LogSubscriber.runtime
  end

  def test_append_info_to_payload
    runtime = CassandraRuntime.new
    payload = {}
    runtime.append_info_to_payload(payload)

    assert_equal 42, payload[:foo]
    assert payload.key?(:cassandra_object_runtime)
  end

  def test_log_process_action
    payload = {cassandra_object_runtime: 12.3}
    messages = CassandraRuntime.log_process_action(payload)

    assert_equal 2, messages.size
    assert_equal "Superstore: 12.3ms", messages.last
  end
end
