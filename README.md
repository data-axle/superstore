# Superstore
[![Build Status](https://travis-ci.org/data-axle/superstore.svg?branch=master)](http://travis-ci.org/data-axle/superstore)
[![Code Climate](https://codeclimate.com/github/data-axle/superstore/badges/gpa.svg)](https://codeclimate.com/github/data-axle/superstore)
[![Gem](https://img.shields.io/gem/v/superstore.svg?maxAge=2592000)](https://rubygems.org/gems/superstore)

Superstore is a PostgreSQL JSONB document store which uses ActiveModel to mimic much of the behavior
in ActiveRecord.

## Requirements

Superstore requires PostgreSQL 9.5 or above.

## Installation

Add the following to the `Gemfile`:

```ruby
gem 'superstore'
```

Superstore will share the existing ActiveRecord database connection.

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
