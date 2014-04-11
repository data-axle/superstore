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

  test 'column family' do
    assert_equal 'Superstore::BaseTest::Sons', Son.column_family
    assert_equal 'Superstore::BaseTest::Sons', Grandson.column_family
  end
end
