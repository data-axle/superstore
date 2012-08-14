module CassandraObject
  class Schema
    module Tasks
      def dump(io)
        column_families.each do |column_family|
          io.puts run_command("DESCRIBE COLUMNFAMILY #{column_family}")
        end
      end

      def column_families
        run_command('DESCRIBE COLUMNFAMILIES').split.sort
      end

      private
        def run_command(command)
          `echo "#{command};" | cqlsh -k #{CassandraObject::Base.connection_config.keyspace}`.sub(/^(.*)$/, '').strip
        end
    end
  end
end