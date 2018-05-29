module Superstore
  module Types
    class DateRangeType < RangeType
      self.subtype = DateType.new
    end
  end
end
