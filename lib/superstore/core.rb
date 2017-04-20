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
    end

    def initialize(attributes=nil)
      @new_record         = true
      @destroyed          = false
      @association_cache  = {}

      @attributes         = {}
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
      @association_cache = {}
      super
    end

    def to_param
      id
    end
  end
end
