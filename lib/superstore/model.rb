module Superstore
  module Model
    def table_name=(table_name)
      @table_name = table_name
    end

    def table_name
      @table_name ||= base_class.name.pluralize
    end

    def column_family
      warn '`column_family` is deprecated & will be removed in superstore 2.0. Use `table_name` instead.'
      table_name
    end

    def column_family=(table_name)
      warn '`column_family=` is deprecated & will be removed in superstore 2.0. Use `table_name=` instead.'
      self.table_name = table_name
    end

    def base_class
      class_of_active_record_descendant(self)
    end

    def config=(config)
      @@config = config.deep_symbolize_keys
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
        raise "#{name} doesn't belong in a hierarchy descending from Superstore"
      else
        class_of_active_record_descendant(klass.superclass)
      end
    end
  end
end
