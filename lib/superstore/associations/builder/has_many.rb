module Superstore::Associations::Builder
  class HasMany < Association
    def macro
      :has_many
    end
  end
end