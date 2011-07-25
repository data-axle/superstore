require 'cassandra_object/types/boolean_type'
require 'cassandra_object/types/date_type'
require 'cassandra_object/types/float_type'
require 'cassandra_object/types/hash_type'
require 'cassandra_object/types/integer_type'
require 'cassandra_object/types/time_type'
require 'cassandra_object/types/time_with_zone_type'
require 'cassandra_object/types/utf8_string_type'

CassandraObject::Type.register(:boolean, Object, CassandraObject::Types::BooleanType)
CassandraObject::Type.register(:date, Date, CassandraObject::Types::DateType)
CassandraObject::Type.register(:float, Float, CassandraObject::Types::FloatType)
CassandraObject::Type.register(:hash, Hash, CassandraObject::Types::HashType)
CassandraObject::Type.register(:integer, Integer, CassandraObject::Types::IntegerType)
CassandraObject::Type.register(:time, Time, CassandraObject::Types::TimeType)
CassandraObject::Type.register(:time_with_zone, ActiveSupport::TimeWithZone, CassandraObject::Types::TimeWithZoneType)
CassandraObject::Type.register(:string, String, CassandraObject::Types::UTF8StringType) #This could be changed to StringType to support non-utf8 strings
CassandraObject::Type.register(:utf8, String, CassandraObject::Types::UTF8StringType)
