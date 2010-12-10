module CassandraObject
  class LogSubscriber < ActiveSupport::LogSubscriber
    def multi_get(event)
      name = 'CassandraObject multi_get (%.1fms)'
      keys = event.payload[:keys].join(" ")

      debug "  #{name}  (#{keys.size}) #{keys}"
    end

    def remove(event)
    end

    def insert(event)
    end
  end
end
CassandraObject::LogSubscriber.attach_to :cassandra_object
