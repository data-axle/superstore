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
          @init_hash = self.hash
          @init_value = hash
        end

        def []=(obj, val)
          modifying { super }
        end

        def delete(obj)
          modifying { super }
        end

        private
        def modifying
          result = yield

          if !record.changed_attributes.key?(name) && @init_hash != self.hash
            record.changed_attributes[name] = @init_value
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
