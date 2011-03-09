require 'cassandra_object/types'

CassandraObject::Base.register_attribute_type(:integer, Integer, CassandraObject::IntegerType)
CassandraObject::Base.register_attribute_type(:float, Float, CassandraObject::FloatType)
CassandraObject::Base.register_attribute_type(:date, Date, CassandraObject::DateType)
CassandraObject::Base.register_attribute_type(:time, Time, CassandraObject::TimeType)
CassandraObject::Base.register_attribute_type(:time_with_zone, ActiveSupport::TimeWithZone, CassandraObject::TimeWithZoneType)
CassandraObject::Base.register_attribute_type(:string, String, CassandraObject::UTF8StringType) #This could be changed to StringType to support non-utf8 strings
CassandraObject::Base.register_attribute_type(:utf8, String, CassandraObject::UTF8StringType)
CassandraObject::Base.register_attribute_type(:hash, Hash, CassandraObject::HashType)
CassandraObject::Base.register_attribute_type(:boolean, Object, CassandraObject::BooleanType)
