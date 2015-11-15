module Superstore::Associations::Builder
  class HasOne < Association
    def macro
      :has_one
    end
  end
end