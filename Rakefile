require 'bundler/setup'
require 'rake'
require 'rake/testtask'

task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
end
