require 'rubygems'
require 'i18n'
require 'active_support'
require 'active_model'


module CassandraObject
  VERSION = "0.6.0"
  extend ActiveSupport::Autoload

  autoload :Base

  require 'cassandra_object/migrator'
  require 'cassandra_object/migration'

  module Tasks
    extend ActiveSupport::Autoload
    autoload :Keyspace
    autoload :ColumnFamily

    require 'cassandra_object/tasks/ks'
  end

  module Generators
    require 'cassandra_object/generators/migration_generator'
  end

end
