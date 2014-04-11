require 'test_helper'

class ActiveModelTest < Superstore::TestCase

  include ActiveModel::Lint::Tests

  # overrides ActiveModel::Lint::Tests#test_to_param
  def test_to_param
  end

  # overrides ActiveModel::Lint::Tests#test_to_key
  def test_to_key
  end

  def setup
    @model = Issue.new
  end
end
