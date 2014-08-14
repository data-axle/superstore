# Superstore
[![Build Status](https://secure.travis-ci.org/data-axle/superstore.png?rvm=2.0.0)](http://travis-ci.org/data-axle/superstore) [![Code Climate](https://codeclimate.com/github/data-axle/superstore.png)](https://codeclimate.com/github/data-axle/superstore)

Cassandra Object uses ActiveModel to mimic much of the behavior in ActiveRecord.

## Installation

Add the following to your Gemfile:
```ruby
gem 'superstore'
```

Change the version of Cassandra accordingly. Recent versions have not been backward compatible.

## Defining Models

```ruby
class Widget < Superstore::Base
  string :name
  string :description
  integer :price
  array :colors, unique: true

  validates :name, presence: :true

  before_create do
    self.description = "#{name} is the best product ever"
  end
end
```

The table name defaults to the case-sensitive, pluralized name of the model class. To specify a
custom name, set the ```table_name``` attribute on the class:

```ruby
class MyWidget < Superstore::Base
  table_name = 'my_widgets'
  # ... same as above
end
```
## Using with Cassandra

Add the cassandra-cql gem to Gemfile:

```ruby
gem 'cassandra-cql'
```
  
Add a config/superstore.yml:

```yaml
development:
  adapter: cassandra
  keyspace: my_app_development
  servers: 127.0.0.1:9160
  thrift:
    timeout: 20
    retries: 2
```

## Using with Postgres HStore

Add the pg gem to your Gemfile:

```ruby
gem 'pg'
```
  
And a config/superstore.yml:

```yaml
development:
  adapter: hstore
```

## Creating and updating records

Cassandra Object has equivalent methods as ActiveRecord:

```ruby
widget = Widget.new
widget.valid?
widget = Widget.create(name: 'Acme', price: 100)
widget.update_attribute(:price, 1200)
widget.update_attributes(price: 1200, name: 'Acme Corporation')
widget.attributes = {price: 300}
widget.price_was
widget.save
widget.save!
```

## Finding records

```ruby
widget = Widget.find(uuid)
widget = Widget.first
widgets = Widget.all
Widget.find_each do |widget|
  # Codez
end
```

## Scoping

Some lightweight scoping features are available:
```ruby
  Widget.where('color' => 'red')
  Widget.select(['name', 'color'])
  Widget.limit(10)
```
