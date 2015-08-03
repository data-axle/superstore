module Superstore
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :symbolized_config
    end

    module ClassMethods
      def table_name=(table_name)
        @table_name = table_name
      end

      def table_name
        @table_name ||= base_class.model_name.plural
      end

      def base_class
        class_of_active_record_descendant(self)
      end

      def config=(config)
        self.symbolized_config = config.deep_symbolize_keys
      end

      def config
        symbolized_config
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
end
