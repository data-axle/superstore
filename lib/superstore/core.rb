module Superstore
  module Core
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Core
      extend ClassOverrides
      include InstanceOverrides
    end

    module ClassOverrides
      def inspect
        if self == Base
          super
        else
          attr_list = attribute_definitions.keys * ', '
          "#{super}(#{attr_list.truncate(140 * 1.7337)})"
        end
      end

      def arel_engine # :nodoc:
        @arel_engine ||=
          if Base == self || connection_handler.retrieve_connection_pool(connection_specification_name)
            self
          else
            superclass.arel_engine
          end
      end
    end

    module InstanceOverrides
      def initialize(attributes=nil)
        self.class.define_attribute_methods
        init_internals

        @attributes     = {}
        self.attributes = attributes || {}

        yield self if block_given?
      end

      def initialize_dup(other)
        @attributes = @attributes.deep_dup
        @attributes['created_at'] = nil
        @attributes['updated_at'] = nil
        @attributes.delete(self.class.primary_key)
        @id = nil

        @new_record = true
        @destroyed = false

        initialize_copy(other)
      end
    end
  end
end
