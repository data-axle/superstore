module CassandraObject
  module Types
    class JsonType < BaseType
      class DirtyHash < Hash
        attr_accessor :record, :name, :options
        def initialize(record, name, hash, options)
          @record   = record
          @name     = name.to_s
          @options  = options

          self.merge!(hash)
        end

        def []=(obj, val)
          modifying do
            super
          end
        end

        def delete(obj)
          modifying do
            super
          end
        end

        private
        def modifying
          unless record.changed_attributes.include?(name)
            original = dup
          end

          result = yield

          if !record.changed_attributes.key?(name) && original != self
            record.changed_attributes[name] = original
          end

          record.send("#{name}=", self)

          result
        end
      end

      def encode(hash)
        ActiveSupport::JSON.encode(hash)
      end

      def decode(str)
        ActiveSupport::JSON.decode(str)
      end

      def wrap(record, name, value)
        DirtyHash.new(record, name, Hash(value), options)
      end

    end
  end
end
