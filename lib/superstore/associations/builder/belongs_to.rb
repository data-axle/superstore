module Superstore::Associations::Builder
  class BelongsTo < Association
    def macro
      :belongs_to
    end
  end
end