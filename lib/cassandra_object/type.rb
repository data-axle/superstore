module CassandraObject
  class Type
    class TypeMapping < Struct.new(:expected_type, :converter)
    end

    cattr_accessor :attribute_types
    self.attribute_types = {}.with_indifferent_access

    class << self
      def register(name, expected_type, converter)
        attribute_types[name] = TypeMapping.new(expected_type, converter)
      end

      def get_mapping(name)
        attribute_types[name]
      end
    end
  end
end
