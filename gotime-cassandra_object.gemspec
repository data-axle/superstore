# version = File.read(File.expand_path("../RAILS_VERSION", __FILE__)).strip
# require 'cassandra_object/version'

Gem::Specification.new do |s|
  s.name = 'gotime-cassandra_object'
  s.version = '0.8.0'
  s.description = 'Cassandra ActiveModel'
  s.summary = 'Cassandra ActiveModel'
  s.required_rubygems_version = '>= 1.3.5'
  s.authors = ["Michael Koziarski", "grantr"]
  s.email = 'grantr@gmail.com'
  s.extra_rdoc_files = ["README.markdown"]
  s.files = %w(MIT-LICENSE Rakefile README.markdown) + Dir['{lib,test}/**/*.rb']
  s.homepage = 'http://github.com/gotime/cassandra_object'
  s.require_path = 'lib'

  s.add_runtime_dependency('activesupport', "~> 3")
  s.add_runtime_dependency('activemodel', "~> 3")
  s.add_runtime_dependency('cassandra')
  s.add_runtime_dependency('nokogiri')

  s.add_development_dependency('shoulda')
  s.add_development_dependency('bundler', "~> 1.0.0")
  s.add_development_dependency('jeweler', "~> 1.5.1")
  s.add_development_dependency('rcov')
end

