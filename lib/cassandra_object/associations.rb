module CassandraObject
  module Associations
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :OneToMany
    autoload :OneToOne
    
    included do
      class_inheritable_hash :associations
    end

    module ClassMethods

      def relationships_column_family=(column_family)
        @relationships_column_family = column_family
      end

      def relationships_column_family
        @relationships_column_family || "#{column_family}Relationships"
      end

      def column_family_configuration
        super << {:Name=>relationships_column_family, :CompareWith=>"UTF8Type", :CompareSubcolumnsWith=>"TimeUUIDType", :ColumnType=>"Super"}
      end
      
      def association(association_name, options= {})
        if options[:unique]
          write_inheritable_hash(:associations, {association_name => OneToOne.new(association_name, self, options)})
        else
          write_inheritable_hash(:associations, {association_name => OneToMany.new(association_name, self, options)})
        end
      end
      
      def remove(key)
        begin
          ActiveSupport::Notifications.instrument("remove.cassandra_object", :key => key) do
            connection.remove("#{name}Relationships", key.to_s, :consistency => write_consistency_for_thrift)
          end
        rescue Cassandra::AccessError => e
          raise e unless e.message =~ /Invalid column family/
        end
        super
      end
    end
  end
end
