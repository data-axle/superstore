require 'rubygems'
require 'i18n'
require 'active_support'
require 'active_model'


module CassandraObject
  VERSION = "0.6.0"
  extend ActiveSupport::Autoload

  autoload :Base

require 'active_support/all'
require 'active_model'

require 'cassandra_object/base'
