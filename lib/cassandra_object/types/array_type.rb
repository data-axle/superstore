module CassandraObject
  module Types
    class ArrayType < BaseType
      class Proxy < BasicObject
        instance_methods.each { |m| undef_method m }
        
        attr_accessor :record, :name, :array, :options
        def initialize(record, name, array, options)
          @record   = record
          @name     = name.to_s
          @array    = array.presence || []
          @options  = options
        end

        def <<(obj)
          modifying do
            array << obj
            array.uniq! if options[:unique]
          end
        end

        private
          def method_missing(method, *args, &block)
            array.send(method, *args, &block)
          end

          def modifying
            unless record.changed_attributes.include?(name)
              original = array.dup
            end

            yield

            if !record.changed_attributes.key?(name) && original.sort != array.sort
              record.changed_attributes[name] = original
            end

            record.send("#{name}=", array)
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