require 'active_support/core_ext/module/attr_internal'
require 'cassandra_object/log_subscriber'

module CassandraObject
  module Railties # :nodoc:
    module ControllerRuntime #:nodoc:
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def log_process_action(payload)
          messages, cassandra_object_runtime = super, payload[:cassandra_object_runtime]
          if cassandra_object_runtime.to_i > 0
            messages << ("CassandraObject: %.1fms" % cassandra_object_runtime.to_f)
          end
          messages
        end
      end

      #private

        attr_internal :cassandra_object_runtime

        def process_action(action, *args)
          # We also need to reset the runtime before each action
          # because of queries in middleware or in cases we are streaming
          # and it won't be cleaned up by the method below.
          CassandraObject::LogSubscriber.reset_runtime
          super
        end

        def cleanup_view_runtime
          runtime_before_render = CassandraObject::LogSubscriber.reset_runtime
          runtime = super
          runtime_after_render = CassandraObject::LogSubscriber.reset_runtime
          self.cassandra_object_runtime = runtime_before_render + runtime_after_render
          runtime - runtime_after_render
        end

        def append_info_to_payload(payload)
          super
          payload[:cassandra_object_runtime] = (cassandra_object_runtime || 0) + CassandraObject::LogSubscriber.reset_runtime
        end
    end
  end
end
