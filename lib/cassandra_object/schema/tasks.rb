module CassandraObject
  class Schema
    module Tasks
      def dump(io)
        column_families.each do |column_family|
          io.puts run_command("DESCRIBE COLUMNFAMILY #{column_family}")
          io.puts
        end
      end

      def load(io)
        current_cql = ''

        io.each_line do |line|
          next if line.blank?

          current_cql << line.rstrip

          if current_cql =~ /;$/
            CassandraObject::Base.execute_cql current_cql
            current_cql = ''
          end
        end
      end

      def column_families
        run_command('DESCRIBE COLUMNFAMILIES').split.sort
      end

      private
        def run_command(command)
          `echo "#{command};" | #{cqlsh} -k #{keyspace} #{server}`.sub(/^(.*)$/, '').strip
        end

        def cqlsh
          ENV['CQLSH'] || 'cqlsh'
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
