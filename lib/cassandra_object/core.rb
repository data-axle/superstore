module CassandraObject
  module Core
    extend ActiveSupport::Concern

    def initialize(attributes=nil)
      @new_record = true
      @destroyed = false
      @attributes = {}
      self.attributes = attributes || {}
      attribute_definitions.each do |attr, attribute_definition|
        unless attribute_exists?(attr)
          @attributes[attr.to_s] = self.class.typecast_attribute(self, attr, nil)
        end
      end

      yield self if block_given?
    end

    def initialize_dup(other)
      @attributes = other.attributes
      @attributes['created_at'] = nil
      @attributes['updated_at'] = nil
      @attributes.delete(self.class.primary_key)
      @id = nil
      @new_record = true
      @destroyed = false
      super
    end

    def to_param
      id
    end

    def hash
      id.hash
    end

    module ClassMethods
      def inspect
        if self == Base
          super
        else
          attr_list = @attributes.map do |col, definition| "#{col}: #{definition.type}" end * ', '
          "#{super}(#{attr_list.truncate(140 * 1.7337)})"
        end
      end
    end

    def ==(comparison_object)
      comparison_object.equal?(self) ||
        (comparison_object.instance_of?(self.class) &&
          comparison_object.id == id)
    end

    def eql?(comparison_object)
      self == (comparison_object)
    end
  end
end
