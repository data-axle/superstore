module CassandraObject
  class Schema
    module Tasks
      def dump(io)
        column_families.each do |column_family|
          p "column_family = #{column_family}"
          io.puts run_command("DESCRIBE COLUMNFAMILY #{column_family}")
          io.puts
        end
      end

      def load(filename)
        `cqlsh -k #{keyspace} -f #{filename} #{server}`
      end

      def column_families
        run_command('DESCRIBE COLUMNFAMILIES').split.sort
      end

      private
        def run_command(command)
          `echo "#{command};" | cqlsh -k #{keyspace} #{server}`.sub(/^(.*)$/, '').strip
        end

        def keyspace
          CassandraObject::Base.connection_config.keyspace
        end

        def server
          CassandraObject::Base.connection_config.servers.first.gsub(/:.*/, '')
        end
    end
  end
end