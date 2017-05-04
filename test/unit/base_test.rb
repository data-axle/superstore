require 'test_helper'

class Superstore::BaseTest < Superstore::TestCase
  class Son < Superstore::Base
  end

  class Grandson < Son
  end

  test 'base_class' do
    assert_equal Superstore::Base, Superstore::Base
    assert_equal Son, Son.base_class
    assert_equal Son, Grandson.base_class
  end

  test 'table_name' do
    assert_equal 'sons', Son.table_name
    assert_equal 'sons', Grandson.table_name
  end

  test 'translations' do
    assert_equal :activerecord, Son.i18n_scope
  end
end
