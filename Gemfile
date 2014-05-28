source "http://rubygems.org"
gemspec

gem 'rake'
gem 'thin'

group :test do
  gem 'rails'
  gem 'pg'
  gem 'activerecord'
  gem 'mocha', require: false
end

group :cassandra do
  gem 'cassandra-cql', "1.1.4"
end
