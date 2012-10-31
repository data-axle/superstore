require 'active_support/core_ext/hash/keys'

module CassandraObject
  class Config
    attr_accessor :servers, :keyspace, :thrift_options, :keyspace_options

    def initialize(options)
      options = options.symbolize_keys
      self.servers  = Array.wrap(options[:servers] || "127.0.0.1:9160")
      self.keyspace = options[:keyspace]
      self.thrift_options = (options[:thrift] || {}).symbolize_keys
      self.keyspace_options = (options[:keyspace_options] || {}).symbolize_keys
    end
  end
end
