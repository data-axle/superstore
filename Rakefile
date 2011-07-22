require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/testtask'

# require File.expand_path('../lib/cassandra_object', __FILE__)

task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end