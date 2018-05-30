module Superstore
  module Types
    class DateRangeType < RangeType
      self.subtype = DateType.new(nil)
    end
  end
end
