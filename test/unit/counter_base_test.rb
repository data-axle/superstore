# require 'test_helper'
#
# class CassandraObject::CounterBaseTest < CassandraObject::TestCase
#   class AppCounts < CassandraObject::CounterBase
#     self.column_family = 'AppCounts'
#   end
#
#   def setup
#     CassandraObject::Schema.create_column_family 'AppCounts', 'default_validation' => 'CounterColumnType', 'replicate_on_write' => 'true'
#   end
#
#   def teardown
#     CassandraObject::Schema.drop_column_family 'AppCounts'
#   end
#
#   test 'class_loading' do
#     assert_equal CassandraObject::CounterBase, CassandraObject::CounterBase
#   end
#
#   test 'single update' do
#
#     AppCounts.update('poop', 'smells', 0)
#
#     assert_equal 0, AppCounts.get("poop", "smells")
#
#     AppCounts.update('poop', 'smells', 60)
#
#     assert_equal 60, AppCounts.get("poop", "smells")
#
#     assert_equal Hash['smells' => 60], AppCounts.get("poop")
#
#   end
#
#   test 'multiple update' do
#
#     AppCounts.update('poop', {'hankey_sightings' => 3, 'christmas_days' => 5})
#
#     assert_equal Hash['hankey_sightings' => 3, 'christmas_days' => 5], AppCounts.get("poop")
#
#     assert_equal 5, AppCounts.get("poop", "christmas_days")
#   end
#
# end
