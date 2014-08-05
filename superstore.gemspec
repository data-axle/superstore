# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'superstore'
  s.version = '1.0.11'
  s.description = 'ActiveModel for many attributes'
  s.summary = 'Cassandra ActiveModel'
  s.authors = ["Michael Koziarski", "gotime"]
  s.email = 'developer@matthewhiggins.com'
  s.homepage = 'http://github.com/data-axle/superstore'

  s.required_ruby_version     = '>= 2.0.0'
  s.required_rubygems_version = '>= 1.3.5'

  s.extra_rdoc_files = ["README.md"]
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency('activemodel', '>= 3.0')

  s.add_development_dependency('bundler')
end
