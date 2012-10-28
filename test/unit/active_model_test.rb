require 'test_helper'

class ActiveModelTest < CassandraObject::TestCase

  include ActiveModel::Lint::Tests

  # overrides ActiveModel::Lint::Tests#test_to_param
  def test_to_param
  end

  def setup
    @model = Issue.new
  end
end
