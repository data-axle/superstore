require 'digest/sha1'
module CassandraObject
  module Identity
    class HashedNaturalKeyFactory < NaturalKeyFactory
      def next_key(object)
        NaturalKey.new(Digest::SHA1.hexdigest(attributes.map { |attribute| object[attribute] }.join(separator)))
      end
    end
  end
end
