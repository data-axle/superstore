module CassandraObject
  module Types
    class ArrayType < BaseType
      class Proxy < BasicObject
        attr_accessor :record, :name, :array, :options
        def initialize(record, name, array, options)
          @record   = record
          @name     = name
          @array    = array.presence || []
          @options  = options
        end

        def <<(obj)
          array << obj
          array.sort!
          array.uniq! if options[:unique]
          record.send("#{name}=", array)
        end

        def method_missing(method, *args, &block)
          array.send(method, *args, &block)
        end
      end

      def ignore_nil?
        false
      end

      def encode(array)
        raise ArgumentError.new("#{self} requires an Array") unless array.kind_of?(Array)
        array.to_a.to_json
      end

      def decode(str)
        array = ActiveSupport::JSON.decode(str)
        array.uniq! if options[:unique]
        array
      end

      def wrap(record, name, value)
        Proxy.new(record, name, value, options)
      end
    end
  end
end