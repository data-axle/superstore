module CassandraObject
  class LogSubscriber < ActiveSupport::LogSubscriber
    def initialize
      super
      @odd_or_even = false
    end

    def cql(event)
      payload = event.payload
      name = '%s (%.1fms)' % [payload[:name], event.duration]
      cql = payload[:cql].squeeze(' ')

      if odd?
        name = color(name, CYAN, true)
        cql  = color(cql, nil, true)
      else
        name = color(name, MAGENTA, true)
      end

      debug "  #{name}  #{cql}"
    end

    def odd?
      @odd_or_even = !@odd_or_even
    end
  end
end

CassandraObject::LogSubscriber.attach_to :cassandra_object
