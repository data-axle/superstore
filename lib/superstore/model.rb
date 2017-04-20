module Superstore
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def base_class
        class_of_active_record_descendant(self)
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
