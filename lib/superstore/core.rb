module Superstore
  module Core
    extend ActiveSupport::Concern

    module ClassMethods
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

    def initialize(attributes=nil)
      @readonly           = false
      @new_record         = true
      @destroyed          = false
      @association_cache  = {}

      @attributes         = {}
      self.attributes = attributes || {}

      @_start_transaction_state = {}
      @transaction_state        = nil

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
      @association_cache = {}

      @_start_transaction_state = {}
      @transaction_state        = nil

      initialize_copy(other)
    end
  end
end
