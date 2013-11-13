module CassandraObject
  module Model
    def column_family=(column_family)
      @column_family = column_family
    end

    def column_family
      @column_family ||= base_class.name.pluralize
    end

    def base_class
      class_of_active_record_descendant(self)
    end

    def config=(config)
      @@config = config.is_a?(Hash) ? CassandraObject::Config.new(config) : config
    end

    def config
      @@config
    end

    private

    # Returns the class descending directly from ActiveRecord::Base or an
    # abstract class, if any, in the inheritance hierarchy.
    def class_of_active_record_descendant(klass)
      if klass == Base || klass.superclass == Base
        klass
      elsif klass.superclass.nil?
        raise "#{name} doesn't belong in a hierarchy descending from CassandraObject"
      else
        class_of_active_record_descendant(klass.superclass)
      end
    end
  end
end
