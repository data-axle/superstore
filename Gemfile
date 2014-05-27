source "http://rubygems.org"
gemspec

gem 'rake'
gem 'thin'

group :test do
  gem 'rails'
  gem 'mocha', require: false
end

group :cassandra do
  gem 'cassandra-cql', "1.1.4"
end

group :hstore do
  gem 'activerecord'
  gem 'pg'
end
