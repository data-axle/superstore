# 2.4.0

Released 2016-08-10.

## New Features

* Rails 5 compatibility (#19)

# 2.3.0

Released 2016-06-29.

## Changed

* Superstore requires PostgreSQL 9.5, since it uses the JSONB operators introduced in that version.

# 2.2.0

Released 2016-06-02.

## New Features

* Add `geo_point` type (#18)

# 2.1.2

Released 2016-05-04.

## Fixed

`Model.find([nil])` no longer returns all records

# 2.1.1

Released 2016-04-01.

## New Features

* Added a `to_ids` scoped method.

# 2.1.0

Released 2016-02-12.

## Changed

* Associations are now ActiveRecord-based (#17)

# 2.0.1

Released 2016-02-12.

## Fixed

* `has_many` was not working correctly.

# 2.0.0

Released 2015-12-18.

## New Features

* **Added Postgres JSONB adapter.** (#9)
* Added support for `has_many` association. (#13)
* Added support for `has_one` association. (#14)

## Breaking Changes

* **Removed Cassandra and Postgres hstore adapters.** (#12)
* `find_each` now uses SQL cursors, so it's not constrained by the limitations of ActiveRecord's
  implementation. (#11)
* Default values have been re-implemented correctly. (#15)
