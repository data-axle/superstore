source "http://rubygems.org"
gemspec

gem 'rake'

group :test do
  gem 'rails'
  gem 'pg'
  gem 'activerecord', '~> 4.2.0'
  gem 'mocha', require: false
end

group :cassandra do
  gem 'cassandra-cql', "1.1.4"
  gem 'thin'
end
