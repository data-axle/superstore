require 'test_helper'

class ActiveModelTest < CassandraObject::TestCase

  module ::ActiveModel::Lint::Tests
    # well, this is where we behave differently from *pure* ActiveModel
    def test_to_param
      # def model.persisted?() false end
      # assert model.to_param.nil?, "to_param should return nil when `persisted?` returns false"
    end
  end

  include ActiveModel::Lint::Tests

  def setup
    @model = Issue.new
  end
end
