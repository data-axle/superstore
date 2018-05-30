module Superstore
  module Types
    class IntegerRangeType < RangeType
      self.subtype = IntegerType.new(Integer)
    end
  end
end
