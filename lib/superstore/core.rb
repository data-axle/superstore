module Superstore
  module Core
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Core
      extend ClassOverrides
      include InstanceOverrides
    end

    module ClassOverrides
      def arel_engine # :nodoc:
        @arel_engine ||=
          if Base == self || connection_handler.retrieve_connection_pool(connection_specification_name)
            self
          else
            superclass.arel_engine
          end
      end
    end

    def initialize_dup(other)
      super

      @attributes.keys.each do |key|
        attribute = @attributes[key]
        if attribute.instance_variable_defined?(:@value)
          attribute.instance_variable_set(:@value, attribute.instance_variable_get(:@value).deep_dup)
        end
      end
    end

    module InstanceOverrides
      def inspect
        inspection = ["#{self.class.primary_key}: #{id.inspect}"]

        (self.class.attribute_names - [self.class.primary_key]).each do |name|
          value = send(name)

          if value.present? || value === false
            inspection << "#{name}: #{attribute_for_inspect(name)}"
          end
        end

        "#<#{self.class} #{inspection * ', '}>"
      end
    end
  end
end
