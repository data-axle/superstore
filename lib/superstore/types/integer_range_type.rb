module Superstore
  module Types
    class IntegerRangeType < RangeType
      self.subtype = IntegerType.new
    end
  end
end
