module Superstore
  class Type
    cattr_accessor :attribute_types
    self.attribute_types = {}.with_indifferent_access

    class << self
      def register(name, type)
        attribute_types[name] = type
      end

      def get_type_class(name)
        attribute_types[name]
      end
    end
  end
end
