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
