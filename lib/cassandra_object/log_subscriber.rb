module CassandraObject
  class LogSubscriber < ActiveSupport::LogSubscriber
    def multi_get(event)
      name = 'CassandraObject multi_get (%.1fms)' % event.duration
      keys = event.payload[:keys].join(" ")

      debug "  #{name}  (#{keys.size}) #{keys}"
    end

    def remove(event)
      name = 'CassandraObject remove (%.1fms)' % event.duration

      debug "  #{name}  #{event.payload[:key]}"
    end

    def insert(event)
      name = 'CassandraObject insert (%.1fms)' % event.duration

      debug "  #{name}  #{event.payload[:key]} #{event.payload[:attributes].inspect}"
    end

    def get_range(event)
      name = 'CassandraObject get_range (%.1fms)' % event.duration
      
      debug "  #{name}  (#{event.payload[:count]}) #{event.payload[:start]} => #{event.payload[:finish]}"
    end
  end
end
CassandraObject::LogSubscriber.attach_to :cassandra_object
