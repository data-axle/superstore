module CassandraObject
  class Schema
    module Tasks
      def dump(io)
        table_names.each do |column_family|
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
            keyspace_execute current_cql
            current_cql = ''
          end
        end
      end

      def table_names
        run_command('DESCRIBE COLUMNFAMILIES').split.sort
      end

      private
        def run_command(command)
          `echo "#{command};" | #{cqlsh} -2 -k #{keyspace} #{server}`.sub(/^(.*)$/, '').strip
        end

        def cqlsh
          ENV['CQLSH'] || 'cqlsh'
        end

        def keyspace
          CassandraObject::Base.config.keyspace
        end

        def server
          CassandraObject::Base.config.servers.first.gsub(/:.*/, '')
        end
    end
  end
end
