# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'gotime-cassandra_object'
  s.version = '2.10.9'
  s.description = 'Cassandra ActiveModel'
  s.summary = 'Cassandra ActiveModel'

  s.required_ruby_version     = '>= 1.9.2'
  s.required_rubygems_version = '>= 1.3.5'

  s.authors = ["Michael Koziarski", "gotime"]
  s.email = 'gems@gotime.com'
  s.homepage = 'http://github.com/gotime/cassandra_object'

  s.extra_rdoc_files = ["README.rdoc"]
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency('activemodel', ">= 3.0")
  s.add_runtime_dependency('cassandra', ">= 0.12.0")

  s.add_development_dependency('bundler')
end
