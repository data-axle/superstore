module Superstore
  module Core
    extend ActiveSupport::Concern

    included do
      include ActiveRecord::Core
      extend ClassOverrides
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
  end
end
