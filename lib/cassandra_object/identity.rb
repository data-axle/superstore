module CassandraObject
  module Identity
    extend ActiveSupport::Concern

    included do
      class_attribute :key_generator

      key do
        SimpleUUID::UUID.new.to_guid
      end
    end

    module ClassMethods
      # Define a key generator. Default is UUID.
      def key(&block)
        self.key_generator = block
      end

      def _generate_key(object)
        object.instance_eval(&key_generator)
      end
    end
  end
end
