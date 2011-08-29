module CassandraObject
  module Types
    class ArrayType < BaseType
      class DirtyArray < Array
        attr_accessor :record, :name, :options
        def initialize(record, name, array, options)
          @record   = record
          @name     = name.to_s
          @options  = options
          super(array.presence || [])
        end

        def <<(obj)
          modifying do
            super
            uniq! if options[:unique]
          end
        end

        private
          def modifying
            unless record.changed_attributes.include?(name)
              original = dup
            end

            yield

            if !record.changed_attributes.key?(name) && original.sort != sort
              record.changed_attributes[name] = original
            end

            record.send("#{name}=", self)
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
        DirtyArray.new(record, name, value, options)
      end
    end
  end
end