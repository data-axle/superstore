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

    module InstanceOverrides
      def initialize(attributes = nil)
        self.class.define_attribute_methods
        init_internals

        @attributes     = FakeAttributeSet.new
        self.attributes = attributes || {}

        yield self if block_given?
        _run_initialize_callbacks
      end

      def initialize_dup(other)
        @id = nil

        super
      end
    end
  end
end
