module CassandraObject
  module AttributeMethods
    class Definition
      attr_reader :name, :coder, :expected_type
      def initialize(name, type_mapping, options)
        @name           = name.to_s
        @coder          = type_mapping.coder.new(options)
        @expected_type  = type_mapping.expected_type
      end

      def instantiate(record, value)
        value ||= coder.default
        return unless value
      
        value = value.kind_of?(expected_type) ? value : coder.decode(value)
        coder.wrap(record, name, value)
      end
    end
  end
end