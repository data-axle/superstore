module Superstore
  module Types
    class IntegerRangeType < RangeType
      self.subtype = IntegerType.new(nil)
    end
  end
end
