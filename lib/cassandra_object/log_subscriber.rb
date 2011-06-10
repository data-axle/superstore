module CassandraObject
  class LogSubscriber < ActiveSupport::LogSubscriber
    def multi_get(event)
      name = 'CassandraObject multi_get %s (%.1fms)' % [event.payload[:column_family], event.duration]

      debug "  #{name}  (#{event.payload[:keys].size}) #{event.payload[:keys].join(" ")}"
    end

    def remove(event)
      name = 'CassandraObject remove %s (%.1fms)' % [event.payload[:column_family], event.duration]

      message = "  #{name}  #{event.payload[:key]}"
      message << " #{Array(event.payload[:attributes]).inspect}" if event.payload[:attributes]

      debug message
    end

    def truncate(event)
      name = 'CassandraObject truncate %s (%.1fms)' % [event.payload[:column_family], event.duration]

      debug "  #{name}  #{event.payload[:column_family]}"
    end

    def insert(event)
      name = 'CassandraObject insert %s (%.1fms)' % [event.payload[:column_family], event.duration]

      debug "  #{name}  #{event.payload[:key]} #{event.payload[:attributes].inspect}"
    end

    def get_range(event)
      name = 'CassandraObject get_range %s (%.1fms)' % [event.payload[:column_family], event.duration]
      
      debug "  #{name}  (#{event.payload[:count]}) '#{event.payload[:start]}' => '#{event.payload[:finish]}'"
    end
  end
end
CassandraObject::LogSubscriber.attach_to :cassandra_object
