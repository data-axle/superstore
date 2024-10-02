Gem::Specification.new do |s|
  s.name = 'superstore'
  s.version = '4.0.0'
  s.description = 'ActiveModel-based JSONB document store'
  s.summary = 'ActiveModel for JSONB documents'
  s.authors = ['Michael Koziarski', 'Data Axle']
  s.email = 'developer@matthewhiggins.com'
  s.homepage = 'http://github.com/data-axle/superstore'
  s.licenses = %w[ISC MIT]

  s.required_ruby_version     = '>= 3.1.0'
  s.required_rubygems_version = '>= 3.2.0'

  s.extra_rdoc_files = ['README.md']
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency('activemodel', '>= 7.0')
  s.add_runtime_dependency('activerecord', '>= 7.0')

  s.add_development_dependency('bundler')
  s.add_development_dependency('rails', '~> 7.0.0')
end
