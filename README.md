# Superstore
[![Build Status](https://secure.travis-ci.org/data-axle/superstore.png?rvm=2.0.0)](http://travis-ci.org/data-axle/superstore) [![Code Climate](https://codeclimate.com/github/data-axle/superstore/badges/gpa.svg)](https://codeclimate.com/github/data-axle/superstore)

Superstore uses ActiveModel to mimic much of the behavior in ActiveRecord.

## Installation

Add the following to the `Gemfile`:
```ruby
gem 'superstore'
```

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
custom name, set the `table_name` attribute on the class:

```ruby
class MyWidget < Superstore::Base
  table_name = 'my_widgets'
end
```
## Using the Cassandra adapter

**Note**: _Change the version of Cassandra accordingly. Recent versions have not been backwards compatible._

Add the `cassandra-cql` gem to the `Gemfile`:

```ruby
gem 'cassandra-cql'
```

Add a `config/superstore.yml` file:

```yaml
development:
  adapter: cassandra
  keyspace: my_app_development
  servers: 127.0.0.1:9160
  thrift:
    timeout: 20
    retries: 2
```

## Using the PostgreSQL JSONB adapter

Add the `pg` gem to the `Gemfile`:

```ruby
gem 'pg'
```

Add a `config/superstore.yml`:

```yaml
development:
  adapter: jsonb
```

Superstore will share the existing ActiveRecord database connection.

## Creating and updating records

Superstore has equivalent methods to ActiveRecord:

```ruby
widget = Widget.new
widget.valid?
widget = Widget.create(name: 'Acme', price: 100)
widget.update_attribute(:price, 1200)
widget.update(price: 1200, name: 'Acme Corporation')
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
