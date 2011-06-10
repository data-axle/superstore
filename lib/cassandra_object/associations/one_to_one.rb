module CassandraObject
  module Associations
    class OneToOne
      def initialize(association_name, owner_class, options)
        @association_name  = association_name.to_s
        @owner_class       = owner_class
        @target_class_name = options[:class_name] || association_name.to_s.camelize 
        @options           = options

        define_methods!
      end

      def define_methods!
        @owner_class.class_eval <<-eos
        def #{@association_name}
          @_#{@association_name} ||= self.class.associations[:#{@association_name}].find(self)
        end

        def #{@association_name}=(record)
          @_#{@association_name} = record
          self.class.associations[:#{@association_name}].set(self, record)
        end
        eos
      end

      def clear(owner)
        ActiveSupport::Notifications.instrument("remove.cassandra_object", :column_family => column_family, :key => owner.key, :columns => @association_name) do
          connection.remove(column_family, owner.key.to_s, @association_name)
        end
      end

      def find(owner)
        if key = connection.get(column_family, owner.key.to_s, @association_name.to_s, :count=>1).values.first
          target_class.get(key)
        else
          nil
        end
      end  

      def set(owner, record, set_inverse = true)
        clear(owner)
        key = owner.key
        attributes = {@association_name=>{new_key=>record.key.to_s}}
        ActiveSupport::Notifications.instrument("insert.cassandra_object", :column_family => column_family, :key => key, :attributes => attributes) do
          connection.insert(column_family, key.to_s, attributes, :consistency => write_consistency_for_thrift)
        end
        if has_inverse? && set_inverse
          inverse.set_inverse(record, owner)
        end
      end

      def new_key
        SimpleUUID::UUID.new
      end

      def set_inverse(owner, record)
        set(owner, record, false)
      end

      def has_inverse?
        @options[:inverse_of]
      end

      def inverse
        has_inverse? && target_class.associations[@options[:inverse_of]]
      end

      def column_family
        @owner_class.relationships_column_family
      end

      def connection
        @owner_class.connection
      end

      def target_class
        @target_class ||= @target_class_name.constantize
      end

      def new_proxy(owner)
        # OneToManyAssociationProxy.new(self, owner)
      end
    end
  end
end
