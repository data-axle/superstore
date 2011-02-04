module CassandraObject
  module Consistency
    VALID_READ_CONSISTENCY_LEVELS = [:one, :quorum, :all]
    VALID_WRITE_CONSISTENCY_LEVELS = VALID_READ_CONSISTENCY_LEVELS

    def valid_read_consistency_level?(level)
      !!VALID_READ_CONSISTENCY_LEVELS.include?(level)
    end

    def valid_write_consistency_level?(level)
      !!VALID_WRITE_CONSISTENCY_LEVELS.include?(level)
    end

    def write_consistency_for_thrift
      consistency_for_thrift(write_consistency)
    end

    def read_consistency_for_thrift
      consistency_for_thrift(read_consistency)
    end

    def consistency_for_thrift(consistency)
      {
        :one    => Cassandra::Consistency::ONE, 
        :quorum => Cassandra::Consistency::QUORUM,
        :all    => Cassandra::Consistency::ALL
      }[consistency]
    end
  end
end
