# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'superstore'
  s.version = '2.4.4'
  s.description = 'ActiveModel-based JSONB document store'
  s.summary = 'ActiveModel for JSONB documents'
  s.authors = ['Michael Koziarski', 'Infogroup']
  s.email = 'developer@matthewhiggins.com'
  s.homepage = 'http://github.com/data-axle/superstore'
  s.licenses = %w(ISC MIT)

  s.required_ruby_version     = '>= 2.0.0'
  s.required_rubygems_version = '>= 1.3.5'

  s.extra_rdoc_files = ['README.md']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency('activemodel', '>= 4.2')
  s.add_runtime_dependency('activerecord', '>= 4.2')
  s.add_runtime_dependency('globalid')
  s.add_runtime_dependency('oj')

  s.add_development_dependency('bundler')
end
