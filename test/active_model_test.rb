require 'test_helper'

class ActiveModelTest < ActiveModel::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = Customer.new
  end
end
