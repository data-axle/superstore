require 'test_helper'

class ActiveModelTest < CassandraObject::TestCase
  # include ActiveModel::Lint::Tests

  def setup
    @model = Issue.new
  end
end
