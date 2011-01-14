module CassandraObject

  module Tasks

    class ColumnFamily

      COMPARATOR_TYPES = { :time      => 'TimeUUIDType',
                           :timestamp => 'TimeUUIDType',
                           :long      => 'LongType',
                           :string    => 'BytesType',
                           :utf8      => 'UTF8Type' }

      COLUMN_TYPES = {     :standard  => 'Standard',
                           :super     => 'Super' }

      def initialize(keyspace)
        @keyspace = keyspace
      end

      def exists?(name)
        connection.schema.cf_defs.find { |cf_def| cf_def.name == name.to_s }
      end

      def create(name, &block)
        cf = Cassandra::ColumnFamily.new
        cf.name = name.to_s
        cf.keyspace = @keyspace.to_s
        cf.comparator_type = 'BytesType'
        cf.column_type = 'Standard'

        block.call cf if block

        post_process_column_family(cf)
        connection.add_column_family(cf)
      end

      def drop(name)
        connection.drop_column_family(name.to_s)
      end

      def rename(old_name, new_name)
        connection.rename_column_family(old_name.to_s, new_name.to_s)
      end

      def clear(name)
        connection.truncate!(name.to_s)
      end

      private

      def connection
        CassandraObject::Base.connection
      end

      def post_process_column_family(cf)
        comp_type = cf.comparator_type
        if comp_type && COMPARATOR_TYPES.has_key?(comp_type)
          cf.comparator_type = COMPARATOR_TYPES[comp_type]
        end

        comp_type = cf.subcomparator_type
        if comp_type && COMPARATOR_TYPES.has_key?(comp_type)
          cf.subcomparator_type = COMPARATOR_TYPES[comp_type]
        end

        col_type = cf.column_type
        if col_type && COLUMN_TYPES.has_key?(col_type)
          cf.column_type = COLUMN_TYPES[col_type]
        end

        cf
      end

    end

  end

end

class Cassandra
  class ColumnFamily
    def with_fields(options)
      struct_fields.collect { |f| f[1][:name] }.each do |f|
        send("#{f}=", options[f.to_sym] || options[f.to_s])
      end
      self
    end
  end
end

