module CassandraObject
  module AttributeMethods
    class Definition
      attr_reader :name, :coder
      def initialize(name, coder, options)
        @name           = name.to_s
        @coder          = coder.new(options)
      end

      def instantiate(record, value)
        value = value.nil? ? coder.default : value
        return unless value

        value = value.kind_of?(String) ? coder.decode(value) : value
        coder.wrap(record, name, value)
      end
    end
  end
end
