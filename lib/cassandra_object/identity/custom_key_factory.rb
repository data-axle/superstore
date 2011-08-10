module CassandraObject
  module Identity
    class CustomKeyFactory < AbstractKeyFactory
      class CustomKey
        include Key

        attr_reader :value

        def initialize(value)
          @value = value
        end

        def to_s
          value
        end

        def to_param
          value
        end

        def ==(other)
          other.is_a?(CustomKey) && other.value == value
        end

        def eql?(other)
          other == self
        end
      end

      attr_reader :method

      def initialize(options)
        @method = options[:method]
      end

      def next_key(object)
        CustomKey.new(object.send(@method))
      end
    end
  end
end

